Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaLBOZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:25:43 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53395 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaLBOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:25:39 -0500
Message-ID: <547DCBDE.6020504@linaro.org>
Date: Tue, 02 Dec 2014 14:25:34 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>
CC: Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 0/3] Qualcomm Resource Power Manager
References: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Thanks for the patches, I tested few regulators which are connected to 
IO devices with this series on IFC6410 with APQ8064 and they work fine. 
Except one issue which you already are aware of "regulator dependencies 
on each other" I guess this is another topic which can be discussed 
separately to this patchset.

Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


--srini
On 26/11/14 21:50, Bjorn Andersson wrote:
> In order to support the SoC assisted power save features of the Qualcomm
> platform some changes are most likely needed to the regulator part of the DT
> bindings provided before.
>
> This version of the patchset carries the RPM core part, which allows us to move
> forward with merging Josh's patches [1] as well as aiding the discussion and
> development of the additional patches needed to properly implement the power
> save features being discussed.
>
> It also carries the patch to the already merged regulator driver, to make it
> compile.
>
> [1] https://lkml.org/lkml/2014/11/20/629
>
> Changes since v7:
>    - Mark merged the regulator part of the previous series
>    - Removed regulator part of dt binding, for further discussions
>
> Changes since v6:
>    - Changed filenames from qcom,rpm.{txt,h} to qcom-rpm.{txt,h}
>
> Changes since v5:
>    - Clarified dt binding
>    - Converted regulator qcom,force-mode to enum instead of multi-boolean
>    - Remove unecessary version handshake
>    - Cleaned up naming of RPM resources between different RPM versions
>    - Updated regulator qcom,force-mode parsing
>    - Updated regulator qcom,power-mode-* parsing
>    - Cleanups in rpm driver
>    - Dropped dev_get_qcom_rpm helper function
>
> Changes since v4:
>    - Moved RPM driver to mfd
>
> Changes since v3:
>    - IPC register is acquired through syscon, as it's shared with others
>
> Changes since v2:
>    - Fix copy-paste error in dt binding
>    - Correct incomplete move from mfd to soc
>    - Correct const mistake in regulator driver
>
> Changes since v1:
>    - Moved rpm driver to drivers/soc
>    - Extracted resource table structs from rpm struct, as per Srinivas request
>    - Dropped mode setting support for the regulators for now. Unsure if we need
>      it and it requires some rework from the codeaurora solution.
>    - Using set_voltage_sel instead of rolling my own "snapping", as per Marks
>      request
>    - Split regulator ops in mV, uV and swtich versions as per Marks request.
>    - Added devicetree property to enable pull down.
>
> Bjorn Andersson (3):
>    mfd: devicetree: bindings: Add Qualcomm RPM DT binding
>    mfd: qcom-rpm: Driver for the Qualcomm RPM
>    regulator: qcom-rpm: Add missing state flag in call to RPM
>
>   Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  70 +++
>   drivers/mfd/Kconfig                                |  14 +
>   drivers/mfd/Makefile                               |   1 +
>   drivers/mfd/qcom_rpm.c                             | 581 +++++++++++++++++++++
>   drivers/regulator/qcom_rpm-regulator.c             |   1 +
>   include/dt-bindings/mfd/qcom-rpm.h                 | 154 ++++++
>   include/linux/mfd/qcom_rpm.h                       |  13 +
>   7 files changed, 834 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm.txt
>   create mode 100644 drivers/mfd/qcom_rpm.c
>   create mode 100644 include/dt-bindings/mfd/qcom-rpm.h
>   create mode 100644 include/linux/mfd/qcom_rpm.h
>
> --
> 1.8.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
