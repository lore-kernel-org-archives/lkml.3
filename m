Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbaAHXV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:21:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57020 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbaAHXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:21:50 -0500
Message-ID: <52CDDD8D.5090100@codeaurora.org>
Date: Wed, 08 Jan 2014 15:21:49 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 1/9] devicetree: bindings: Document Krait/Scorpion
 cpus and enable-method
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org> <1387845593-10050-2-git-send-email-sboyd@codeaurora.org> <20140108142139.GJ6701@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140108142139.GJ6701@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 06:21, Mark Rutland wrote:
> On Tue, Dec 24, 2013 at 12:39:45AM +0000, Stephen Boyd wrote:
>> From: Rohit Vaswani <rvaswani@codeaurora.org>
>>
>> Scorpion and Krait don't use the spin-table enable-method.
>> Instead they rely on mmio register accesses to enable power and
>> clocks to bring CPUs out of reset. Document their enable-methods.
>>
>> Cc: <devicetree@vger.kernel.org>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> [sboyd: Split off into separate patch, renamed methods to
>> match compatible nodes]
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/arm/cpus.txt | 25 ++++++++++++++++++++++++-
>>  1 file changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
>> index 9130435..333f4ae 100644
>> --- a/Documentation/devicetree/bindings/arm/cpus.txt
>> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
>> @@ -180,7 +180,11 @@ nodes to be present and contain the properties described below.
>>  			  be one of:
>>  			     "spin-table"
>>  			     "psci"
>> -			# On ARM 32-bit systems this property is optional.
>> +			# On ARM 32-bit systems this property is optional and
>> +			  can be one of:
>> +			    "qcom,gcc-msm8660"
>> +			    "qcom,kpss-acc-v1"
>> +			    "qcom,kpss-acc-v2"
> It would be nice to document "psci" here as valid for 32-bit.
>
> Currently the PSCI code doesn't inspect the enable-method and assumes it
> if there's a psci node, but KVM tool and others set enable-method to
> "psci", and if we change the way the PSCI code probes it will require
> enable-method to be set for PSCI to work.

Sure. I'll squash it in if I resend, or send a follow-up patch later on.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

