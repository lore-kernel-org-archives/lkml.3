Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaEWHNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:13:21 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48051 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaEWHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:13:19 -0400
Message-ID: <537EF50B.2010101@linaro.org>
Date: Fri, 23 May 2014 08:13:15 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
CC: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH v2 00/14] Add Qualcomm SD Card Controller support
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org> <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,
I like to get this patches for v3.16,  any chance of considering these 
patches to v3.16 ?

--srini

On 15/05/14 10:34, srinivas.kandagatla@linaro.org wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Thankyou everyone for reviewing both RFC and v1 patches.
>
> This patch series adds Qualcomm SD Card Controller support in pl180 mmci
> driver. QCom SDCC is basically a pl180, but bit more customized, some of the
> register layouts and offsets are different to the ones mentioned in pl180
> datasheet. The plan is to totally remove the standalone SDCC driver
> drivers/mmc/host/msm_sdcc.* and start using generic mmci driver for all
> Qualcomm parts, as we get chance to test on other Qcom boards.
>
> To start using the existing mmci driver, a fake amba id for Qualcomm is added
> in patches:
>   mmc: mmci: Add Qualcomm Id to amba id table.
>
> Second change is, adding a 3 clock cycle delay for register writes on QCOM SDCC
> registers, which is done in patches:
>    mmc: mmci: Add register read/write wrappers.
>    mmc: mmci: Qcomm: Add 3 clock cycle delay after register write
>
> Third change is to accommodate CLK, DATCTRL and MMCICLK register layout changes
> in Qcom SDCC and provide more flexibity in driver to specify these changes via
> variant datastructure. Which are done in patches:
>    mmc: mmci: Add Qcom datactrl register variant
>    mmc: mmci: add ddrmode mask to variant data
>    mmc: mmci: add 8bit bus support in variant data
>    mmc: mmci: add edge support to data and command out in variant data.
>    mmc: mmci: add Qcom specifics of clk and datactrl registers.
>    mmc: mmci: Add support to data commands via variant structure.
>    mmc: mmci: add support for fbclk to latch data and cmd.
>    mmc: mmci: add qcom specific clk control
>
> Fourth major change was to add qcom specfic pio read function, the need for
> this is because the way MCIFIFOCNT register behaved in QCOM SDCC is very
>   different to the one in pl180. This change is done in patch:
>    mmc: mmci: Add Qcom specific pio_read function.
>
> Last some Qcom unrelated changes/cleanup to driver are done in patches:
>    mmc: mmci: use NSEC_PER_SEC macro
>    mmc: mmci: convert register bits to use BIT() macro.
>
> This patches are tested in PIO mode on IFC8064 board with both eMMC and
> external SD card. I would like to get this support in v3.16.
>
> Changes from v1:
> 	- moved most of the SOC specifics to variant parameters as suggested
> 	  by Linus W.
> 	- renamed registers as suggested by Linus W.
> 	- Added comments in the code as suggested by Linus W.
> 	- moved out AMBA ID addition patch from this series.
> 	- rebased the patches to
> 		git://git.linaro.org/people/ulf.hansson/mmc.git next
> 	  as suggested by Ulf H.
>
> Changes from RFC:
> 	- moved out clk setup out of spinlock as pointed by Stephen B.
> 	
> Thanks,
> srini
>
> Srinivas Kandagatla (14):
>    mmc: mmci: use NSEC_PER_SEC macro
>    mmc: mmci: convert register bits to use BIT() macro.
>    mmc: mmci: Add Qualcomm Id to amba id table
>    mmc: mmci: Add Qcom datactrl register variant
>    mmc: mmci: Add register read/write wrappers.
>    mmc: mmci: Qcomm: Add 3 clock cycle delay after register write
>    mmc: mmci: add ddrmode mask to variant data
>    mmc: mmci: add 8bit bus support in variant data
>    mmc: mmci: add edge support to data and command out in variant data.
>    mmc: mmci: add Qcom specifics of clk and datactrl registers.
>    mmc: mmci: Add support to data commands via variant structure.
>    mmc: mmci: add support for fbclk to latch data and cmd.
>    mmc: mmci: add qcom specific clk control
>    mmc: mmci: Add Qcom specific pio_read function.
>
>   drivers/mmc/host/mmci.c | 245 ++++++++++++++++++++++++++++++++++++------------
>   drivers/mmc/host/mmci.h | 232 +++++++++++++++++++++++++--------------------
>   2 files changed, 311 insertions(+), 166 deletions(-)
>
