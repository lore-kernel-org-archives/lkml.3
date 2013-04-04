Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638Ab3DDGal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:30:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:22807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763424Ab3DDGak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,405,1363158000"; 
   d="scan'208";a="313415653"
Message-ID: <515D1F4E.1080306@intel.com>
Date: Thu, 04 Apr 2013 09:35:58 +0300
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
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>  <1363224194-7366-1-git-send-email-ynvich@gmail.com>  <87620jmkoe.fsf@octavius.laptop.org>  <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>  <87ppylf429.fsf@octavius.laptop.org> <515ADEDE.3050707@intel.com> <1364912689.3399.7.camel@host5.opentask.org>
In-Reply-To: <1364912689.3399.7.camel@host5.opentask.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/13 17:24, Sergey Yanovich wrote:
> On Tue, 2013-04-02 at 16:36 +0300, Adrian Hunter wrote:
>> On my system it is significant:
>>
>> Before the patch:
>>
>> [    1.625623] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
>>
>> After the patch:
>>
>> [    1.935851] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
>>
>> That is an addition of 310 ms which is 19% performance degradation.
> 
> Are you sure the delay is caused by mmc?

Yes

> 
> On my intel laptop (userspace is Debian/unstable):
> [    1.542339] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> ...
> [    2.735851] mmc0: new high speed SD card at address e624
> [    2.742289] mmcblk0: mmc0:e624 SU02G 1.84 GiB 
> [    2.752317]  mmcblk0: p1


No,  I am booting from eMMC.

> 
>> Please revert the patch.
> 
> Chris, could provide a pointer on how to improve the patch?
> 
> Maybe introduce mmc_is_hosting_root() and do something like:
> 
> -	mmc_flush_scheduled_work();
> +	if (mmc_is_hosting_root())
> +		mmc_flush_scheduled_work();

No, I am booting from eMMC.  Perhaps a host capability:

	if (host->caps2 & MMC_CAP2_ROOTWAIT)
		mmc_flush_scheduled_work();

