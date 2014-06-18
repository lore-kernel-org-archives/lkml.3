Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbaFRIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:34:20 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45900 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146AbaFRIeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:34:13 -0400
Message-ID: <53A14F00.9010904@linaro.org>
Date: Wed, 18 Jun 2014 09:34:08 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT
 binding
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com> <1402944372-31901-2-git-send-email-bjorn.andersson@sonymobile.com> <53A0D651.20605@codeaurora.org>
In-Reply-To: <53A0D651.20605@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/06/14 00:59, Stephen Boyd wrote:
> On 06/16/14 11:46, Bjorn Andersson wrote:
>> diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
>> new file mode 100644
>> index 0000000..0366533
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
>> @@ -0,0 +1,260 @@
>> +Qualcomm Resource Power Manager (RPM)
>> +
> [...]
>> +
>> +- reg:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: two entries specifying the RPM's message ram and ipc register
>> +
>> +- reg-names:
>> +	Usage: required
>> +	Value type: <string-array>
>> +	Definition: must contain the following, in order:
>> +		    "msg_ram"
>> +		    "ipc"
>
> ipc is concerning....
>
>> +	rpm@108000 {
>> +		compatible = "qcom,rpm-msm8960";
>> +		reg = <0x108000 0x1000 0x2011008 0x4>;
>> +
>
> (reg-names is missing from the example)
>
> because ipc is actually a register inside the Krait complex's global
> clock control/distribution hardware block (it's located at 0x2011000).
>  From what I can tell, this is the only non-clock/power register inside
> there. I plan to send out a driver for this hardware block so that I can
> switch the L2 aux source mux over to PLL8 instead of PXO (done with a
> single register write to 0x2011028) and this mapping/use here is going
> to conflict with that unless I only map the single register like is done
> here.
>
> I wonder if we'd be better off making this region a separate node and
> having some phandle to it here in the RPM node? That way we have a

Can't we use syscon based on regmap here?  syscon is a better way to 
share a common register space across multiple drivers.

> driver that provides a clock and some IPC handle the RPM driver can get.
> The SMD driver also uses the same register to kick other processors so
> having some generic IPC handle may be useful there too.
>
