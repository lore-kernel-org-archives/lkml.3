Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaIYVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:22:48 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57028 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaIYVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:22:46 -0400
Message-ID: <54248791.9060805@gmail.com>
Date: Thu, 25 Sep 2014 14:22:25 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>
CC: devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH v2 0/6] Add initial support for Broadcom Cygnus SoC
References: <Jonathan Richardson <jonathar@broadcom.com> <1411507057-14771-1-git-send-email-jonathar@broadcom.com> <54248344.5030308@broadcom.com>
In-Reply-To: <54248344.5030308@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On 09/25/2014 02:04 PM, Scott Branden wrote:
> Hi Matt/Christian (and others),
> 
> We would like to move forward in getting our base Cygnus support into
> the mainline kernel.  From there we will be able to contribute
> additional drivers.
> 
> Is somebody willing to accept this pull request to get this patchset
> accepted by the open source community?

I am fine with taking the ARM patches and putting them at
http://github/brcm/linux.git, with C code in cygnus/board and the Device
Tree files in cygnus/dt for instance?

The clock driver patch will have to go through Mike Turquette's tree
unless he wants to delegate that one.

> 
> Regards,
>  Scott
> 
> 
> On 14-09-23 02:17 PM, Jonathan Richardson wrote:
>> Hi,
>>
>> This patchset contains initial support for Broadcom's Cygnus SoC based
>> on our
>> iProc architecture. Initial support is minimal and includes just the mach
>> platform code, clock driver, and a basic device tree configuration.
>> Peripheral
>> drivers will be submitted soon, as will device tree configurations for
>> other
>> Cygnus board variants.
>>
>> Changes from v1:
>>   - Address code review comments as per previous responses.
>>   - Copyright headers updated to remove Broadcom URL.
>>   - mach platform code still contains hard coded adresses. These
>> address are
>>     the same for all Cygnus variants. Could you please provide
>> guidance on where
>>     they should go if you would still like them changed.
>>
>> Thanks,
>> Jon
>>
>> Jonathan Richardson (6):
>>    ARM: cygnus: Initial support for Broadcom Cygnus SoC
>>    clk: Clock driver support for Broadcom Cygnus SoC
>>    dt-bindings: Document Broadcom Cygnus SoC and clock driver
>>    ARM: dts: Enable Broadcom Cygnus SoC
>>    ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC
>>    MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock
>>      drivers
>>
>>   Documentation/devicetree/bindings/arm/cygnus.txt   |   12 +
>>   .../devicetree/bindings/clock/clk-cygnus.txt       |  121 ++
>>   .../devicetree/bindings/clock/clk-iproc.txt        |   48 +
>>   MAINTAINERS                                        |   21 +
>>   arch/arm/boot/dts/Makefile                         |    1 +
>>   arch/arm/boot/dts/bcm-cygnus.dtsi                  |  349 ++++++
>>   arch/arm/boot/dts/bcm911360_entphn.dts             |   22 +
>>   arch/arm/configs/bcm_cygnus_defconfig              |  223 ++++
>>   arch/arm/mach-bcm/Kconfig                          |   31 +
>>   arch/arm/mach-bcm/Makefile                         |    3 +
>>   arch/arm/mach-bcm/bcm_cygnus.c                     |  166 +++
>>   drivers/clk/Makefile                               |    1 +
>>   drivers/clk/bcm/Makefile                           |    2 +
>>   drivers/clk/bcm/clk-cygnus.c                       | 1186
>> ++++++++++++++++++++
>>   drivers/clk/bcm/clk-iproc.c                        |  451 ++++++++
>>   15 files changed, 2637 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/arm/cygnus.txt
>>   create mode 100644
>> Documentation/devicetree/bindings/clock/clk-cygnus.txt
>>   create mode 100644
>> Documentation/devicetree/bindings/clock/clk-iproc.txt
>>   create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
>>   create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
>>   create mode 100644 arch/arm/configs/bcm_cygnus_defconfig
>>   create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c
>>   create mode 100644 drivers/clk/bcm/clk-cygnus.c
>>   create mode 100644 drivers/clk/bcm/clk-iproc.c
>>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

