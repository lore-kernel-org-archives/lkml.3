Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaGaI67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:58:59 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:41695 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaGaI6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:58:55 -0400
Message-ID: <53DA054D.2050508@mm-sol.com>
Date: Thu, 31 Jul 2014 11:58:53 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Collins <collinsd@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 2/4] mfd: pm8xxx-spmi: document DT bindings for Qualcomm
 SPMI PMICs
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com> <1406205921-7452-3-git-send-email-svarbanov@mm-sol.com> <53D81EE1.7040309@codeaurora.org>
In-Reply-To: <53D81EE1.7040309@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 01:23 AM, David Collins wrote:
> On 07/24/2014 05:45 AM, Stanimir Varbanov wrote:
>> Document DT bindings used to describe the Qualcomm SPMI PMICs.
>> Currently the SPMI PMICs supported are pm8941, pm8841 and pma8084.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> (...)
>> +Required properties for peripheral child nodes:
>> +- compatible:      Should contain "qcom,pm8xxx-xxx", where "xxx" is
>> +                   peripheral name. The "pm8xxx" can be any of supported PMICs,
>> +                   see example below.
> 
> I don't think that this binding document should be imposing any formatting
> restrictions on the compatible strings for QPNP peripheral drivers.  The
> QPNP peripheral drivers in the downstream msm-3.10 tree [1] do not specify
> per-PMIC compatible strings.  This is because ideally, a given QPNP
> peripheral represents a hardware block that is identical in interface and
> operation between PMICs.
> 

Isn't "hardware block that is identical in interface and operation
between PMICs" exactly the meaning of *compatible* property?

No *compatible* property, no platform device. We must have this property
for every peripheral driver.

> These peripheral drivers determine the base address for a given device
> instance via device tree reg and reg-names properties.  In order for this
> to continue to work with the pm8xxx-spmi driver, some mechanism will need
> to be introduced which creates resource structs for the
> non-memory-mappable SPMI base addresses.  One possible solution is
> currently being discussed in another thread [2].  This document will need
> to be updated to show the child node reg property scheme once a solution
> is reached.
> 

That's correct. If we reach the "reg" solution this binding document
must be changed.

> (...)
>> +Example:
>> +
>> +	pm8941@0 {
>> +		compatible = "qcom,pm8941";
>> +		reg = <0x0 SPMI_USID>;
>> +
>> +		rtc {
>> +			compatible = "qcom,pm8941-rtc";
>> +			interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
>> +			interrupt-names = "alarm";
>> +		};
>> +	};
> 
> Can you please expand your example to include the second SID for the
> PM8941 chip?  That way, it will be clear that each PMIC needs two DT
> nodes; one for each SID.

Sure, will do.

-- 
regards,
Stan
