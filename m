Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600Ab3DBNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:31:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:25082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761289Ab3DBNbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,393,1363158000"; 
   d="scan'208";a="221869296"
Message-ID: <515ADEDE.3050707@intel.com>
Date: Tue, 02 Apr 2013 16:36:30 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>, Sergey Yanovich <ynvich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com> <1363224194-7366-1-git-send-email-ynvich@gmail.com> <87620jmkoe.fsf@octavius.laptop.org> <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com> <87ppylf429.fsf@octavius.laptop.org>
In-Reply-To: <87ppylf429.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/13 13:57, Chris Ball wrote:
> Hi,
> 
> On Wed, Mar 27 2013, Ulf Hansson wrote:
>> I noticed you merged this. I thought the idea was to use the rootwait
>> or rootdelay?
> 
> That's necessary before the patch, but it would be better if we didn't
> have to pass rootwait, all else being equal.
> 
>> Moreover, this patch will have bad impact on booting the kernel, since
>> every host device that has scheduled a detect work from it's probe
>> function will also wait for it to finish. Even if it is the boot
>> device of not. If this is needed, I would prefer that a host cap is
>> used.
> 
> I see, you're worried about a performance regression where every boot
> takes longer than it used to while MMC quiesces.  That's fair.  Do you
> think you could tell me how much delay this adds to a boot for you, so
> that we can consider whether the usability improvement is worth it?
> 
> If the delay's significant, I agree with you and will revert this patch.

On my system it is significant:

Before the patch:

[    1.625623] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.

After the patch:

[    1.935851] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.

That is an addition of 310 ms which is 19% performance degradation.

Please revert the patch.


