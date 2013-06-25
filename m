Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3FYRlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:41:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56410 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3FYRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:41:29 -0400
Message-ID: <51C9D645.6030609@codeaurora.org>
Date: Tue, 25 Jun 2013 10:41:25 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1371851554-4492-1-git-send-email-hanumant@codeaurora.org> <CACRpkdbcscJYRgTQv_4SdR3i3PJwWfYQu=OonABz3xyLO+3Ubg@mail.gmail.com>
In-Reply-To: <CACRpkdbcscJYRgTQv_4SdR3i3PJwWfYQu=OonABz3xyLO+3Ubg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 05:18 AM, Linus Walleij wrote:

>> +
>> +  - qcom,gp-pull: Pull up/down configuration.
>> +  - qcom,gp-drv: Drive strength configuration.
>> +  - qcom,gp-dir: Pull up/down configuration in power down mode.
> 
> Rebase this to use the generic pin config mappings and parsing
> code that can be found in the "devel" branch of the pinctrl tree.
> 
>> +  The following pin configurations are properties are supported by SDC pins
>> +  - qcom,sdc1-clk-pull: Pull up/down configuration SDC1 clock pin.
>> +  - qcom,sdc1-clk-drv: Drive strength configuration for SDC1 clock pin.
>> +  - qcom,sdc1-cmd-pull: Pull up/down configuration for SDC1 command pin.
>> +  - qcom,sdc1-cmd-drv: Drive strength configuration for SDC1 command pin.
>> +  - qcom,sdc1-data-pull: Pull up/down configuration for SDC1 data pin.
>> +  - qcom,sdc1-data-drv: Drive strength configuration for SDC1 data pin.
>> +  - qcom,sdc2-clk-pull: Pull up/down configuration SDC2 clock pin.
>> +  - qcom,sdc2-clk-drv: Drive strength configuration for SDC2 clock pin.
>> +  - qcom,sdc2-cmd-pull: Pull up/down configuration for SDC2 command pin.
>> +  - qcom,sdc2-cmd-drv: Drive strength configuration for SDC2 command pin.
>> +  - qcom,sdc2-data-pull: Pull up/down configuration for SDC2 data pin.
>> +  - qcom,sdc2-data-drv: Drive strength configuration for SDC2 data pin.
> 
> I don't understand why each sdc thing needs its own definition
> for everything. Please use the generic pin config bindings, call the
> generic parser function and then reject if someone tries to config
> something that is not supported.
>

The register semantics of SDC1 clk, command, and data lines, pull up and
drive strength attributes differ from SDC2 clk, command and data lines.

In general the TLMM v3 has more pin types then just the general/multi
purpose(gp) and SDC pin types above.
There are some pin types on the TLMM, whose config attributes do not
fall under the cattegories supported by generic pin config.
These attributes in some cases happen to be protocol specific.
Hence I would prefer to go with a custom config pack and unpack
implementation rather then the generic one.

> 
>> +Example 4: Set up the default pin state for spi controller.
>> +
>> +       static inline int msm_spi_request_pins{struct msm_spi *dd)
>> +       {
>> +               /* ... */
>> +               dd->pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>> +       }
> 
> Nowadays the device core will do this, so this is not any good
> advice. (See commit ab78029ecc347debbd737f06688d788bd9d60c1d)

I will modify this.

> 
> I will look closer at this when it uses generic pinconf and
> generic pinconf DT bindings, let's target v3.12.
> 
> Yours,
> Linus Walleij
> 


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, hosted by The Linux Foundation
-- 
