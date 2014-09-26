Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaIZA2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:28:53 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45046 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaIZA2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:28:51 -0400
X-IronPort-AV: E=Sophos;i="5.04,601,1406617200"; 
   d="scan'208";a="47024354"
Message-ID: <5424B335.6000602@broadcom.com>
Date: Thu, 25 Sep 2014 17:28:37 -0700
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>,
        <devicetree@vger.kernel.org>, <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: Re: [PATCH v2 0/6] Add initial support for Broadcom Cygnus SoC
References: <Jonathan Richardson <jonathar@broadcom.com> <1411507057-14771-1-git-send-email-jonathar@broadcom.com> <54248344.5030308@broadcom.com> <54248791.9060805@gmail.com> <5424AFD2.2070406@gmail.com>
In-Reply-To: <5424AFD2.2070406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-25 05:14 PM, Florian Fainelli wrote:
> Scott, Jonathan,
> 
> On 09/25/2014 02:22 PM, Florian Fainelli wrote:
>> Hi Scott,
>>
>> On 09/25/2014 02:04 PM, Scott Branden wrote:
>>> Hi Matt/Christian (and others),
>>>
>>> We would like to move forward in getting our base Cygnus support into
>>> the mainline kernel.  From there we will be able to contribute
>>> additional drivers.
>>>
>>> Is somebody willing to accept this pull request to get this patchset
>>> accepted by the open source community?
>>
>> I am fine with taking the ARM patches and putting them at
>> http://github/brcm/linux.git, with C code in cygnus/board and the Device
>> Tree files in cygnus/dt for instance?
>>
>> The clock driver patch will have to go through Mike Turquette's tree
>> unless he wants to delegate that one.
> 
> Could you resend patch 3 without the clock binding, patch 4 without the
> clocks node, and patch 6 without the drivers/clk changes? Once you do
> that, I can assemble these patches quickly and send a pull request which
> does only contain ARM SoC and DTS changes, and you can get the clock
> driver to be reviewed separately by its maintainer?

The serial driver needs a clock so probably better not to pull out the
clock nodes. It's part of the core functionality we'd like in the
initial Cygnus support. I didn't hear from Mike (cc'd), though Mark
reviewed it.

Thanks.

> 
> Thanks!
> 
>>
>>>
>>> Regards,
>>>  Scott
>>>
>>>
>>> On 14-09-23 02:17 PM, Jonathan Richardson wrote:
>>>> Hi,
>>>>
>>>> This patchset contains initial support for Broadcom's Cygnus SoC based
>>>> on our
>>>> iProc architecture. Initial support is minimal and includes just the mach
>>>> platform code, clock driver, and a basic device tree configuration.
>>>> Peripheral
>>>> drivers will be submitted soon, as will device tree configurations for
>>>> other
>>>> Cygnus board variants.
>>>>
>>>> Changes from v1:
>>>>   - Address code review comments as per previous responses.
>>>>   - Copyright headers updated to remove Broadcom URL.
>>>>   - mach platform code still contains hard coded adresses. These
>>>> address are
>>>>     the same for all Cygnus variants. Could you please provide
>>>> guidance on where
>>>>     they should go if you would still like them changed.
>>>>
>>>> Thanks,
>>>> Jon
>>>>
>>>> Jonathan Richardson (6):
>>>>    ARM: cygnus: Initial support for Broadcom Cygnus SoC
>>>>    clk: Clock driver support for Broadcom Cygnus SoC
>>>>    dt-bindings: Document Broadcom Cygnus SoC and clock driver
>>>>    ARM: dts: Enable Broadcom Cygnus SoC
>>>>    ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC
>>>>    MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock
>>>>      drivers
>>>>
>>>>   Documentation/devicetree/bindings/arm/cygnus.txt   |   12 +
>>>>   .../devicetree/bindings/clock/clk-cygnus.txt       |  121 ++
>>>>   .../devicetree/bindings/clock/clk-iproc.txt        |   48 +
>>>>   MAINTAINERS                                        |   21 +
>>>>   arch/arm/boot/dts/Makefile                         |    1 +
>>>>   arch/arm/boot/dts/bcm-cygnus.dtsi                  |  349 ++++++
>>>>   arch/arm/boot/dts/bcm911360_entphn.dts             |   22 +
>>>>   arch/arm/configs/bcm_cygnus_defconfig              |  223 ++++
>>>>   arch/arm/mach-bcm/Kconfig                          |   31 +
>>>>   arch/arm/mach-bcm/Makefile                         |    3 +
>>>>   arch/arm/mach-bcm/bcm_cygnus.c                     |  166 +++
>>>>   drivers/clk/Makefile                               |    1 +
>>>>   drivers/clk/bcm/Makefile                           |    2 +
>>>>   drivers/clk/bcm/clk-cygnus.c                       | 1186
>>>> ++++++++++++++++++++
>>>>   drivers/clk/bcm/clk-iproc.c                        |  451 ++++++++
>>>>   15 files changed, 2637 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/arm/cygnus.txt
>>>>   create mode 100644
>>>> Documentation/devicetree/bindings/clock/clk-cygnus.txt
>>>>   create mode 100644
>>>> Documentation/devicetree/bindings/clock/clk-iproc.txt
>>>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
>>>>   create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
>>>>   create mode 100644 arch/arm/configs/bcm_cygnus_defconfig
>>>>   create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c
>>>>   create mode 100644 drivers/clk/bcm/clk-cygnus.c
>>>>   create mode 100644 drivers/clk/bcm/clk-iproc.c
>>>>
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 

