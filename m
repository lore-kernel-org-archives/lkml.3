Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3KERo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:44:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60831 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3KERoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:44:25 -0500
Message-ID: <52792E78.4060600@codeaurora.org>
Date: Tue, 05 Nov 2013 09:44:24 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 03/11] devicetree: bindings: Document qcom,kpss-acc
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-4-git-send-email-sboyd@codeaurora.org> <EA8C3C10-2AD6-4179-A785-12001E439364@codeaurora.org>
In-Reply-To: <EA8C3C10-2AD6-4179-A785-12001E439364@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 09:13, Kumar Gala wrote:
> On Nov 1, 2013, at 5:08 PM, Stephen Boyd wrote:
>
>> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>> new file mode 100644
>> index 0000000..ed4a9c8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>> @@ -0,0 +1,21 @@
>> +* Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
>> +
>> +The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
>> +There is one ACC register region per CPU within the KPSS remaped region as
>> +well as an alias register region that remaps accesses to the ACC associated
>> +with the CPU accessing the region.
>> +
>> +Required Properties:
>> +
>> +- compatible : Shall contain "qcom,kpss-acc-v1" or "qcom,kpss-acc-v2".
>> +- reg: Specifies the base address and size of the banked register region.
>> +- cpu-offset : per-cpu offset used when the device is accessed without the
>> +		CPU remapping facilities.
>> +		The offset is cpu-offset + (0x10000 * cpu-nr).
>> +
>> +Example:
>> +
>> +	clock-controller@2008000 {
>> +		compatible = "qcom,kpss-acc-v2";
>> +		reg = <0x02008000 0x1000>;
>> +	};
>> -- 
> I don't get the cpu-offset business, shouldn't this just be:
> 	reg = <0x02008000 0x1000>, <0x02018000 0x1000>, <0x02028000 0x1000>, <0x02038000 0x1000>;
>

(Sorry I forgot to add the cpu-offset to the example.)

Your reg property is one way to do it. I was following the example of
the GIC binding which just specifies the alias region of the GIC's CPU
registers and then has a cpu-offset property to describe how to reach a
specific CPU's region.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

