Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967642AbaFQW30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:29:26 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38518 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966415AbaFQVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:37 -0400
Message-ID: <53A0B7ED.9050806@linaro.org>
Date: Tue, 17 Jun 2014 22:49:33 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
CC: Lee Jones <lee.jones@linaro.org>, Josh Cartwright <joshc@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Thankyou for the patches, these were handy for testing USB on APQ8064.

Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

--srini

On 16/06/14 19:46, Bjorn Andersson wrote:
> This series adds a regulator driver for the Resource Power Manager found in
> Qualcomm 8660, 8960 and 8064 based devices.
>
> The RPM driver exposes resources to its child devices, that can be accessed to
> implement drivers for the regulators, clocks and bus frequency control that's
> owned by the RPM in these devices.
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
>    soc: devicetree: bindings: Add Qualcomm RPM DT binding
>    soc: qcom-rpm: Driver for the Qualcomm RPM
>    regulator: qcom-rpm: Regulator driver for the Qualcomm RPM
>
>   .../devicetree/bindings/soc/qcom/qcom,rpm.txt      | 261 +++++++
>   drivers/regulator/Kconfig                          |  12 +
>   drivers/regulator/Makefile                         |   1 +
>   drivers/regulator/qcom_rpm-regulator.c             | 787 +++++++++++++++++++++
>   drivers/soc/qcom/Kconfig                           |  14 +
>   drivers/soc/qcom/Makefile                          |   1 +
>   drivers/soc/qcom/qcom_rpm.c                        | 573 +++++++++++++++
>   include/dt-bindings/soc/qcom,rpm.h                 | 142 ++++
>   include/linux/soc/qcom_rpm.h                       |  12 +
>   9 files changed, 1803 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
>   create mode 100644 drivers/regulator/qcom_rpm-regulator.c
>   create mode 100644 drivers/soc/qcom/qcom_rpm.c
>   create mode 100644 include/dt-bindings/soc/qcom,rpm.h
>   create mode 100644 include/linux/soc/qcom_rpm.h
>
