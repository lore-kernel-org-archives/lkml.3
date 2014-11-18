Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaKRIse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:48:34 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:60570 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbaKRIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:48:32 -0500
Message-ID: <546B07BD.4030400@st.com>
Date: Tue, 18 Nov 2014 09:47:57 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
        <arnd@arndb.de>
Cc: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] Add stih410 SoC/board and USB2/1.1 support for
 stih416
References: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-18_04:2014-11-15,2014-11-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/17/2014 05:47 PM, Peter Griffin wrote:
> Hi folks,
>
> This series adds the required device tree nodes to enable the usb2/1.1 phy
> and usb2/1.1 controllers on the stih416-b2120 board.
>
> It additionally re-works and adds support for the new stih410 SoC which is
> very similar to the stih407 SoC, by abstracting out the common parts
> into common dt files.
>
> After Arnds feedback regarding mixing address spaces in the stih407-picophy
> dt nodes, I've tempoarily removed these patches from the series until the
> underlying driver has been fixed, as ideally I would like to get the rest
> of this series into 3.19
>
> As well as adding dt nodes it also enables the relevant drivers in the
> multi_v7_defconfig.
>
> Finally we update the default bootargs for stih407-b2120 and stih410-b2120
> to boot with the clk_ignore_unused kernel parameter so as not to hang
> the SoC when the (as yet) unreferenced interconnect clocks get disabled
> by CCF (this is a tempoary solution).
>
> This series has been tested on stih416-b2020 and stih410-b2120 SoC/boards.
>
> Changes since v1:
> - Leave bootargs & memory dt nodes in board files (Arnd)
> - Remove '0x' from the unit address in all instances. (Arnd)
> - Remove 'status="okay"' from some nodes (Arnd)
> - Remove some legacy extra nodes which only contain status property (Arnd)
> - Fix stih410 commit description (Maxime)
> - Add a stih410.dtsi and stih410-pinctrl.dtsi files (Maxime)
> - Remove superflous '\n' (Lee)
> - Add a '\n' between the sentries and #include (Lee)
>
> Changes since v2:
> - Remove picophy and ehci/ohci dt nodes for stih407 / stih410 until reg binding is fixed
> - Update miphy365 over to common convention of phy@ (Arnd)
>
> Peter Griffin (11):
>    ARM: STi: DT: STiH416: Add pinctl setup for usb controllers.
>    ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
>    ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb
>      controllers.
>    ARM: multi_v7_defconfig: Enable st ohci and ehci HCD drivers.
>    ARM: multi_v7_defconfig: Enable stih415/6 usb2 phy driver.
>    ARM: STi: DT: STiH410: Add defines for STiH410 DT clocks
>    ARM: STi: DT: STiH410:  Add pinctl config for usb controllers.
>    ARM: STi: DT: STih407: Abstract common dt nodes into shared files.
>    ARM: STi: DT: STiH410: Add STiH410 SoC and b2120 board support.
>    ARM: STi: DT: STih407: STih410: Add clk_ignore_unused to kernel
>      bootargs
>    ARM: STi: DT: STiH416: Change miphy356 node name to phy@fe382000

For the series,

     Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

     If Arnd is fine with the series, these patches will be part of my 
next pull request.

Regards,
Maxime

>
>   arch/arm/boot/dts/Makefile               |   1 +
>   arch/arm/boot/dts/stih407-b2120.dts      |  55 +----
>   arch/arm/boot/dts/stih407-family.dtsi    | 278 +++++++++++++++++++++++++
>   arch/arm/boot/dts/stih407.dtsi           | 279 -------------------------
>   arch/arm/boot/dts/stih410-b2120.dts      |  29 +++
>   arch/arm/boot/dts/stih410-clock.dtsi     | 338 +++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/stih410-pinctrl.dtsi   |  34 ++++
>   arch/arm/boot/dts/stih410.dtsi           |  14 ++
>   arch/arm/boot/dts/stih416-b2020.dts      |   2 +-
>   arch/arm/boot/dts/stih416-b2020e.dts     |   2 +-
>   arch/arm/boot/dts/stih416-pinctrl.dtsi   |  34 ++++
>   arch/arm/boot/dts/stih416.dtsi           | 131 +++++++++++-
>   arch/arm/boot/dts/stihxxx-b2120.dtsi     |  59 ++++++
>   arch/arm/configs/multi_v7_defconfig      |   3 +
>   include/dt-bindings/clock/stih410-clks.h |  25 +++
>   15 files changed, 951 insertions(+), 333 deletions(-)
>   create mode 100644 arch/arm/boot/dts/stih407-family.dtsi
>   delete mode 100644 arch/arm/boot/dts/stih407.dtsi
>   create mode 100644 arch/arm/boot/dts/stih410-b2120.dts
>   create mode 100644 arch/arm/boot/dts/stih410-clock.dtsi
>   create mode 100644 arch/arm/boot/dts/stih410-pinctrl.dtsi
>   create mode 100644 arch/arm/boot/dts/stih410.dtsi
>   create mode 100644 arch/arm/boot/dts/stihxxx-b2120.dtsi
>   create mode 100644 include/dt-bindings/clock/stih410-clks.h
>

