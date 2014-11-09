Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaKIGtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 01:49:12 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55066 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaKIGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 01:49:10 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <545F05F0.3000702@broadcom.com>
References: <sbranden@broadcom.com>
	<1414525992-3678-1-git-send-email-sbranden@broadcom.com>
	<1414525992-3678-5-git-send-email-sbranden@broadcom.com>
	<CAOesGMjUE-Z3L=FU1nspv5M52UhhJ9-dBLr40RTCz2WEhEPHLA@mail.gmail.com>
	<545F05F0.3000702@broadcom.com>
Date: Sat, 8 Nov 2014 22:49:09 -0800
Message-ID: <CAOesGMhd37UM+7+6eR9iLY22Fb9cG1dr8dD4DAzLJNRmtysnkg@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] ARM: dts: Enable Broadcom Cygnus SoC
From: Olof Johansson <olof@lixom.net>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2014 at 10:13 PM, Scott Branden <sbranden@broadcom.com> wrote:
> On 14-11-08 04:22 PM, Olof Johansson wrote:
>>
>> Hi,
>>
>> A bunch of small comments below, should be quick to fix.
>>
>> On Tue, Oct 28, 2014 at 12:53 PM, Scott Branden <sbranden@broadcom.com>
>> wrote:
>>>
>>> DT files to enable cygnus consisting on reference designs
>>> and cygnus core configuration.
>>>
>>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>>> Reviewed-by: Arun Parameswaran <aparames@broadcom.com>
>>> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
>>> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
>>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>> ---
>>>   arch/arm/boot/dts/Makefile              |    4 ++
>>>   arch/arm/boot/dts/bcm-cygnus-clock.dtsi |   73 ++++++++++++++++++++++
>>>   arch/arm/boot/dts/bcm-cygnus.dtsi       |  100
>>> +++++++++++++++++++++++++++++++
>>>   arch/arm/boot/dts/bcm911360_entphn.dts  |   32 ++++++++++
>>>   arch/arm/boot/dts/bcm911360k.dts        |   32 ++++++++++
>>>   arch/arm/boot/dts/bcm958300k.dts        |   32 ++++++++++
>>>   6 files changed, 273 insertions(+)
>>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
>>>   create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
>>>   create mode 100644 arch/arm/boot/dts/bcm911360k.dts
>>>   create mode 100644 arch/arm/boot/dts/bcm958300k.dts
>>>
>>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>>> index 38c89ca..4b3a590 100644
>>> --- a/arch/arm/boot/dts/Makefile
>>> +++ b/arch/arm/boot/dts/Makefile
>>> @@ -54,6 +54,10 @@ dtb-$(CONFIG_ARCH_AT91)      += at91-sama5d4ek.dtb
>>>   dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
>>>   dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
>>>   dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>>> +dtb-$(CONFIG_ARCH_BCM_CYGNUS) += \
>>> +       bcm911360_entphn.dtb \
>>> +       bcm911360k.dtb \
>>> +       bcm958300k.dtb
>>>   dtb-$(CONFIG_ARCH_BCM_5301X) += bcm4708-netgear-r6250.dtb
>>>   dtb-$(CONFIG_ARCH_BCM_63XX) += bcm963138dvt.dtb
>>>   dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb \
>>
>>
>> Please add new entries in alphabetical/alphanumerical order. Also,
>> first entry is commonly added on the first line
>>
>>
>>> diff --git a/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>>> b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>>> new file mode 100644
>>> index 0000000..d06172b
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>>> @@ -0,0 +1,73 @@
>>> +/*
>>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>>> + *
>>> + * Unless you and Broadcom execute a separate written software license
>>> + * agreement governing use of this software, this software is licensed
>>> to you
>>> + * under the terms of the GNU General Public License as
>>> + * published by the Free Software Foundation version 2.
>>> + *
>>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>>> + * kind, whether express or implied; without even the implied warranty
>>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>
>>
>> We ask for new DT contents to be added with dual BSD/GPL license, to
>> allow for reuse of the DT data structures in other projects as well.
>> There's currently a lot of activity going on relicensing the current
>> files so I recommend sorting it out before they are added if you can.
>
>
> This may take more time than you think.  I am going to have to go through
> legal to get such a license created. Also, why would you need dual license?
> If it is BSD that should serve both purposes?

I haven't followed the discussion close enough to know if there's been
discussion about single-license BSD vs dual BSD/GPL.

At the very least, please start the process of getting it changed.

Also, I see now that this isn't even a clean GPL v2, given "Unless you
and Broadcom..." language. I see the bnx2x driver had that in the
past, but none of the Kona contributions did. I strongly suggest
sticking to the normal copyrights here and not making things more
complicated than they have to.


-Olof
