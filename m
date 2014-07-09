Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaGIPvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:51:51 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:43300 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbaGIPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:51:49 -0400
Message-ID: <53BD64E4.5060504@st.com>
Date: Wed, 9 Jul 2014 17:51:00 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ulf.hansson@linaro.org>, <chris@printf.net>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>
Cc: <lee.jones@linaro.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 00/10] Add SDHCI support for ST Microelectronics SoCs
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-09_05:2014-07-09,2014-07-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/09/2014 05:07 PM, Peter Griffin wrote:
> This series adds a SDHCI platform driver for ST SoCs, along with
> the additional device tree bindings and configuration to enable
> the controller to work properly.
>
> Initially it supports the stih416 and stih415 SoCs, and has
> been tested on a stih416-b2020 board.
>
> regards,
>
> Peter.
>
> Changes since v1
> - Whitespace cleanups
> - Use readl_relaxed io accessor
> - Add update to MAINTAINERS
> - Remove reset controller code from platform driver
> - Remove #ifdef around sleep ops
> - Use sdhci_pltfm_clk_get_max_clock lib function
> - Pass bus-width etc through board device tree node
> - Remove unncessary header
> - Remove / change some debug messages
> - Remove final break from switch case
>
> Changes since v2
> - Update CC list with alkml and lkml lists
>
> Changes since v3
> - Rebased on v3.16-rc4
> - Use sdhci_set_bus_width lib function for set_bus_width
> - Remove sdhci_st_8bit_width function
> - Use sdhci_set_clock lib function for set_clock
>
> Peter Griffin (10):
>    mmc: sdhci-st: Intial support for ST SDHCI controller
>    mmc: sdhci-st: ST Microelectronics SDHCI binding documentation.
>    ARM: STi: DT: Add sdhci pins for stih416
>    ARM: STi: DT: Add sdhci controller for stih416
>    ARM: STi: DT: Add sdhci pin configuration for stih415
>    ARM: STi: DT: Add sdhci controller for stih415
>    ARM: STi: DT: Enable mmc0 for both stih415 and stih416 SoCs
>    ARM: STi: DT: Enable second sdhci controller for stih416 b2020 boards.
>    ARM: update multi_v7_defconfig for STI
>    MAINTAINERS: Add sdhci-st file to ARCH/STI architecture
>
>   Documentation/devicetree/bindings/mmc/sdhci-st.txt |  33 ++++
>   MAINTAINERS                                        |   1 +
>   arch/arm/boot/dts/stih415-pinctrl.dtsi             |  21 +++
>   arch/arm/boot/dts/stih415.dtsi                     |  12 ++
>   arch/arm/boot/dts/stih416-b2020.dts                |   8 +
>   arch/arm/boot/dts/stih416-b2020e.dts               |   6 +
>   arch/arm/boot/dts/stih416-pinctrl.dtsi             |  39 +++++
>   arch/arm/boot/dts/stih416.dtsi                     |  24 +++
>   arch/arm/boot/dts/stih41x-b2020.dtsi               |   4 +
>   arch/arm/boot/dts/stih41x-b2020x.dtsi              |   4 +
>   arch/arm/configs/multi_v7_defconfig                |   1 +
>   drivers/mmc/host/Kconfig                           |  12 ++
>   drivers/mmc/host/Makefile                          |   1 +
>   drivers/mmc/host/sdhci-st.c                        | 176 +++++++++++++++++++++
>   14 files changed, 342 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-st.txt
>   create mode 100644 drivers/mmc/host/sdhci-st.c
>

Thanks Peter.

DT patches queued to git://git.stlinux.com/devel/kernel/linux-sti.git 
sti-dt-for-v3.17-1

Regards,
Maxime
