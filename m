Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaDZDFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 23:05:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:40891 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaDZDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 23:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,931,1389772800"; 
   d="scan'208";a="527662239"
Message-ID: <535B2250.2010509@linux.intel.com>
Date: Sat, 26 Apr 2014 11:04:48 +0800
From: "Jin, Yao" <yao.jin@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Adam Williamson <awilliam@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>	 <5353A1F6.60602@linux.intel.com> <5353B8A4.1080900@linux.intel.com>	 <1398007690.2674.0.camel@adam.happyassassin.net>	 <5354BA59.2000008@linux.intel.com> <53551D0F.40906@linux.intel.com>	 <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>	 <1398230210.2704.8.camel@adam.happyassassin.net>	 <20140423083430.GV30677@intel.com> <20140423122344.GX30677@intel.com>	 <5359120E.2030007@linux.intel.com>	 <1398375234.2708.122.camel@adam.happyassassin.net>	 <CACRpkdasjd2HGR199_aqhemAnJD5z6--=Rr=tSoJX_hJ6-ukFA@mail.gmail.com> <1398438814.2708.141.camel@adam.happyassassin.net>
In-Reply-To: <1398438814.2708.141.camel@adam.happyassassin.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/25 23:13, Adam Williamson wrote:
> On Fri, 2014-04-25 at 11:32 +0200, Linus Walleij wrote:
>> On Thu, Apr 24, 2014 at 11:33 PM, Adam Williamson <awilliam@redhat.com> wrote:
>>
>>> Well, I just ran another test too. I built a kernel (3.15rc2) with both
>>> v3 of Doug's SDIO device enumeration patch -
>>> http://dougvj.net/baytrail_gpio_quirk_v3.patch - and the new patch for
>>> the IRQ allocation issue by Thomas Gleixner,
>>> https://patchwork.kernel.org/patch/4051581/ . That kernel gives me a
>>> working touchscreen. Note that
>>> http://dougvj.net/baytrail_gpio_quirk_v3.patch includes both the blocks
>>> you mention (i.e. it adds INT33FC in both places).
>>>
>>> So, it really seems like for me at least, it's the combination of Doug's
>>> patch and your approach to fixing the IRQ allocation issue that breaks
>>> the touchscreen. Thomas' approach, even combined with Doug's patch,
>>> seems to work fine.
>>
>> Please make sure to provide a Tested-by: tag to Thomas so he
>> knows this is merge material.
> 
> Well, I'd rather someone test on the box that's actually affected by the
> IRQ allocation conflict lockups so we can confirm it actually fixes
> them :)
> 

I have tried the Thomas Gleixner's patch on 3.14.0 with i915 loading,
the irq conflict disappears.
