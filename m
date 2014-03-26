Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaCZXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:09:29 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47087 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688AbaCZXJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <53330387.7000803@mm-sol.com>
References: <1394465833-22581-1-git-send-email-gdjakov@mm-sol.com>
	<53330387.7000803@mm-sol.com>
Date: Thu, 27 Mar 2014 00:09:24 +0100
Message-ID: <CAPDyKFqjjgWnH4Lt7vOPSM09ngvY1N6ustaBU41tZCJoKWrkzw@mail.gmail.com>
Subject: Re: [PATCH v11 0/3] mmc: sdhci-msm: Add support for Qualcomm chipsets
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Chris Ball <chris@printf.net>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2014 17:42, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> Hello Chris, Ulf,
>
> Do you have any comments on the patches?
> The arch code that will use this driver is already in mainline. The
> regulators support seem to be still on its way, but this driver also works
> fine with dummy regulators.

Looks good to me!

For the complete patchset:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

>
> Thanks,
> Georgi
>
>
>
> On 03/10/2014 05:37 PM, Georgi Djakov wrote:
>>
>> This patchset adds basic support of the Secure Digital Host Controller
>> Interface compliant controller found in Qualcomm SoCs.
>>
>> Tested with eMMC and various micro SD cards on APQ8074 Dragonboard.
>> Applies to linux-next.
>>
>> Changes from v10:
>> - Make reg-names and interrupt-names optional (suggested by Rob Herring)
>> - Use the common names (vmmc, vqmmc) for regulators (suggested by Ulf
>> Hansson)
>> - Use the sdhci core to take care of regulators and clock (suggested by
>> Ulf
>>    Hansson and Bjorn Andersson)
>> - Cleanup of unused variables and defines
>>
>> Changes from v9:
>> - Make platform_execute_tuning() static (suggested by Josh Cartwright)
>> - Fix buffer size in platform_execute_tuning() (suggested by Josh
>> Cartwright)
>> - Fix typo in patch subject (suggested by Kumar Gala)
>> - Move voltage ranges from DT to the driver (suggested by Bjorn Andersson)
>> - Simplify sdhci_msm_setup_vreg and irq handler (suggested by Bjorn
>> Andersson)
>> - Disable prw irq in sdhci_msm_remove (suggested by Bjorn Andersson)
>> - Fail on peripheral clock errors (suggested by Bjorn Andersson)
>> - Remove unnecessary core_memres assignment (suggested by Bjorn Andersson)
>> - Fixes on freeing resources in probe() (suggested by Bjorn Andersson)
>>
>> Changes from v8:
>> - Added controller version suffix to the DT compatible string.
>> - Switched Kconfig dependency from ARCH_MSM to the new ARCH_QCOM
>> multiplatform.
>> - Addressed comments from Stephen Boyd on the 3rd patch (execute tunning).
>> - Added signed-off-by lines of the initial driver authors.
>> - Picked up tested-by. https://lkml.org/lkml/2013/11/14/85
>> - Minor changes on comments, prints and formatting.
>>
>> Changes from v7:
>> - Added call to sdhci_get_of_property().
>> - Refactored sdhci_msm_dt_parse_vreg_info().
>> - Fixed possible ERR_PTR() dereferencing.
>> - Updated DT binding documentation.
>> - Removed lpm and currents from DT.
>> - Removed bus-speed-mode from DT.
>> - Updated and moved the sanity checks.
>> - Various typo and coding style fixes.
>> - Added platform_execute_tunning implementation.
>>
>> Changes from v6:
>> - Fixed wrong pointer in sdhci_msm_pwr_irq().
>> - Added platform_execute_tuning() callback as the MSM SDHC does not
>>    support tuning as in SDHC 3.0 spec and will need custom implementation
>>    in order to support SDR104, HS200 and HS400.
>> - Removed the always-on devicetree property - if the regulator is
>>    configured as always-on, it will not be disabled anyway.
>> - Removed devm_pinctrl_get_select_default() - the default pins are
>>    already set from the device core.
>> - Removed wrapper function sdhci_msm_set_vdd_io_vol() and enum
>>    vdd_io_level and now calling regulator_set_voltage() directly.
>> - Converted #defines to use BIT() macro.
>> - Added IS_ERR(vreg->reg) check at the beginning of sdhci_msm_vreg
>>    functions.
>> - Do not print errors when regulators init return -EPROBE_DEFER as the
>>    deffered init is not an actual error.
>> - Handle each power irq status bit separately in sdhci_msm_pwr_irq().
>> - Ensure that any pending power irq is acknowledged before enabling it,
>>    otherwise the irq handler will be fired prematurely.
>> - Minor changes.
>>
>> Changes from v5:
>> - Driver is split into multiple patches
>> - Do not initialize variables that are assigned later in code
>> - Remove some useless comments
>> - Use shorter variable names
>> - Change pr_err() to dev_err()
>> - Optimized sdhci_msm_setup_vreg()
>> - Some code alignment fixes
>> - Improved DT values sanity check
>> - Added dev_dbg print for sdhci controller version in probe()
>> - Added usleep_range() after SW reset - it can take some time
>> - Added SDHCI_QUIRK_SINGLE_POWER_WRITE - power handled by PMIC
>> - Renamed DT property vdd-io to vddio
>>
>> Changes from v4:
>> - Simplified sdhci_msm_vreg_disable() and sdhci_msm_set_vdd_io_vol()
>> - Use devm_ioremap_resource() instead of devm_ioremap()
>> - Converted IS_ERR_OR_NULL to IS_ERR
>> - Disable regulators in sdhci_msm_remove()
>> - Check for DT node at the beginning in sdhci_msm_probe()
>> - Removed more redundant code
>> - Changes in some error messages
>> - Minor fixes
>>
>> Changes from v3:
>> - Allocate memory for all required structs at once
>> - Added termination entry in sdhci_msm_dt_match[]
>> - Fixed a missing sdhci_pltfm_free() in probe()
>> - Removed redundant of_match_ptr
>> - Removed the unneeded function sdhci_msm_vreg_reset()
>>
>> Changes from v2:
>> - Added DT bindings for clocks
>> - Moved voltage regulators data to platform data
>> - Removed unneeded includes
>> - Removed obsolete and wrapper functions
>> - Removed error checking where unnecessary
>> - Removed redundant _clk suffix from clock names
>> - Just return instead of goto where possible
>> - Minor fixes
>>
>> Georgi Djakov (3):
>>    mmc: sdhci-msm: Qualcomm SDHCI binding documentation
>>    mmc: sdhci-msm: Initial support for Qualcomm chipsets
>>    mmc: sdhci-msm: Add platform_execute_tuning implementation
>>
>>   .../devicetree/bindings/mmc/sdhci-msm.txt          |   55 ++
>>   drivers/mmc/host/Kconfig                           |   13 +
>>   drivers/mmc/host/Makefile                          |    1 +
>>   drivers/mmc/host/sdhci-msm.c                       |  618
>> ++++++++++++++++++++
>>   4 files changed, 687 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>>   create mode 100644 drivers/mmc/host/sdhci-msm.c
>>
>
