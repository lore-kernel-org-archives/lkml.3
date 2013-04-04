Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab3DDL3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:29:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:21497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322Ab3DDL3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,408,1363158000"; 
   d="scan'208";a="222762614"
Message-ID: <515D6568.7000702@intel.com>
Date: Thu, 04 Apr 2013 14:35:04 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Yanovich <ynvich@gmail.com>
CC: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>   <1363224194-7366-1-git-send-email-ynvich@gmail.com>   <87620jmkoe.fsf@octavius.laptop.org>   <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>   <87ppylf429.fsf@octavius.laptop.org> <515ADEDE.3050707@intel.com>  <1364912689.3399.7.camel@host5.opentask.org> <515D1F4E.1080306@intel.com> <1365073152.9806.26.camel@host5.omatika.ru>
In-Reply-To: <1365073152.9806.26.camel@host5.omatika.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 13:59, Sergey Yanovich wrote:
> On Thu, 2013-04-04 at 09:35 +0300, Adrian Hunter wrote:
>> No,  I am booting from eMMC.
> 
> Well, in this case you should be aware, that your system is not
> concurrency-safe without the patch. It may or may not boot each time
> depending on the large number of factors.

Not true.  You know nothing of my boot time characteristics.

> 
>>> Maybe introduce mmc_is_hosting_root() and do something like:
>>>
>>> -	mmc_flush_scheduled_work();
>>> +	if (mmc_is_hosting_root())
>>> +		mmc_flush_scheduled_work();
>>
>> No, I am booting from eMMC.  Perhaps a host capability:
>>
>> 	if (host->caps2 & MMC_CAP2_ROOTWAIT)
>> 		mmc_flush_scheduled_work();
>>
> 
> Neither my variant, nor yours will help to handle the increased boot
> time.

Not true.  I would not set MMC_CAP2_ROOTWAIT.

> The root cause is that probing several devices is done sequentially and
> mmc was reporting end of its probing before it was actually happening.

Not true.  The probe of the MMC Host Controller finishes when the host
controller is initialized.

> My patch makes mmc report end of probing on-time. The correct way to fix
> the additional delay, my patch introduces, is to rewrite the probing to
> be parallel instead of sequential. I understand that it is much easier
> just to revert the patch.
> 
> If the patch is reverted, something like this somewhere in
> 'init/do_mounts.c' could conditionally activate 'root_wait':
> 
> 	if (mmc_is_hosting_root())
> 		root_wait = 1;
> 
> IMHO this is wrong and my patch is right, but better this than broken
> mmc boot.

No.  Your patch is not right for my platform.

