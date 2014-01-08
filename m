Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaAHOWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:22:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51145 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbaAHOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:22:16 -0500
Date: Wed, 8 Jan 2014 14:21:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
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
Message-ID: <20140108142139.GJ6701@e106331-lin.cambridge.arm.com>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
 <1387845593-10050-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387845593-10050-2-git-send-email-sboyd@codeaurora.org>
Thread-Topic: [PATCH v2 1/9] devicetree: bindings: Document Krait/Scorpion
 cpus and enable-method
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:39:45AM +0000, Stephen Boyd wrote:
> From: Rohit Vaswani <rvaswani@codeaurora.org>
> 
> Scorpion and Krait don't use the spin-table enable-method.
> Instead they rely on mmio register accesses to enable power and
> clocks to bring CPUs out of reset. Document their enable-methods.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> [sboyd: Split off into separate patch, renamed methods to
> match compatible nodes]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 9130435..333f4ae 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -180,7 +180,11 @@ nodes to be present and contain the properties described below.
>  			  be one of:
>  			     "spin-table"
>  			     "psci"
> -			# On ARM 32-bit systems this property is optional.
> +			# On ARM 32-bit systems this property is optional and
> +			  can be one of:
> +			    "qcom,gcc-msm8660"
> +			    "qcom,kpss-acc-v1"
> +			    "qcom,kpss-acc-v2"

It would be nice to document "psci" here as valid for 32-bit.

Currently the PSCI code doesn't inspect the enable-method and assumes it
if there's a psci node, but KVM tool and others set enable-method to
"psci", and if we change the way the PSCI code probes it will require
enable-method to be set for PSCI to work.

>  
>  	- cpu-release-addr
>  		Usage: required for systems that have an "enable-method"
> @@ -191,6 +195,21 @@ nodes to be present and contain the properties described below.
>  			  property identifying a 64-bit zero-initialised
>  			  memory location.
>  
> +	- qcom,saw
> +		Usage: required for systems that have an "enable-method"
> +		       property value of "qcom,kpss-acc-v1" or
> +		       "qcom,kpss-acc-v2"
> +		Value type: <phandle>
> +		Definition: Specifies the SAW[1] node associated with this CPU.
> +
> +	- qcom,acc
> +		Usage: required for systems that have an "enable-method"
> +		       property value of "qcom,kpss-acc-v1" or
> +		       "qcom,kpss-acc-v2"
> +		Value type: <phandle>
> +		Definition: Specifies the ACC[2] node associated with this CPU.
> +
> +
>  Example 1 (dual-cluster big.LITTLE system 32-bit):

If this is going to get much longer, we should probably have
Documentation/devicetree/bindings/arm/boot/ or similar, but that can be
done later.

Otherwise, this looks fine to me.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
