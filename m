Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3JQPbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:31:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36829 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3JQPbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <525FFA40.9050901@wwwdotorg.org>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-4-git-send-email-syin@broadcom.com>
	<CAEPRUYqfpdp1GqxBgx-q=hyvQDe4uyi6okzHPW2QmfmPG_Z3NQ@mail.gmail.com>
	<525FFA40.9050901@wwwdotorg.org>
Date: Thu, 17 Oct 2013 08:31:31 -0700
Message-ID: <CAEPRUYq5DA982AqAmrUpsb3qc30VaFBawaXKTp2pcDvdbM-S1g@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Christian Daudt <bcm@fixthebug.org>
To: Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:54 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/17/2013 12:03 AM, Christian Daudt wrote:
>> On Thu, Oct 3, 2013 at 5:23 PM, Sherman Yin <syin@broadcom.com> wrote:
>>> Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
>>>
>>> Signed-off-by: Sherman Yin <syin@broadcom.com>
>>> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
>>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>>> ---
>>>  arch/arm/mach-bcm/Kconfig       |    2 +
>>>  drivers/pinctrl/Kconfig         |   10 +
>>>  drivers/pinctrl/Makefile        |    1 +
>>>  drivers/pinctrl/pinctrl-capri.c | 1727 +++++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 1740 insertions(+)
>>>  create mode 100644 drivers/pinctrl/pinctrl-capri.c
>>>
>>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>>> index 69d67f7..2546365 100644
>>> --- a/arch/arm/mach-bcm/Kconfig
>>> +++ b/arch/arm/mach-bcm/Kconfig
>>> @@ -10,6 +10,8 @@ config ARCH_BCM
>>>         select GENERIC_CLOCKEVENTS
>>>         select GENERIC_TIME
>>>         select GPIO_BCM
>>> +       select PINCTRL
>>> +       select PINCTRL_CAPRI
>>>         select SPARSE_IRQ
>>>         select TICK_ONESHOT
>>>         select CACHE_L2X0
>>
>> On your subsequent patchset pls move this from Kconfig to
>> arm/configs/bcm_defconfig, and break that modification into a separate
>> patch from the drivers/* modification.
>
> The other SoCs I'm familiar with all select this from their ARCH_xxx
> config symbol.
>
I had a discussion on what is best left under ARCH and what is best
left to defconfig with Kevin Hilman a while back and the conclusion
was that any config not strictly required for bootup is best left to
defconfig. This will allow multiplatform kernels to switch to using
them as loadable modules later on, something not possible with configs
put under ARCH_xxx.

 Thanks,
    csd
