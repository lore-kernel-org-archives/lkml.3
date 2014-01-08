Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbaAHOg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:36:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51551 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069AbaAHOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:36:54 -0500
Date: Wed, 8 Jan 2014 14:36:26 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 3/9] devicetree: bindings: Document qcom,saw2 node
Message-ID: <20140108143626.GB11753@e106331-lin.cambridge.arm.com>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
 <1387845593-10050-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387845593-10050-4-git-send-email-sboyd@codeaurora.org>
Thread-Topic: [PATCH v2 3/9] devicetree: bindings: Document qcom,saw2 node
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:39:47AM +0000, Stephen Boyd wrote:
> The saw2 binding describes the SPM/AVS wrapper hardware used to
> control the regulator supplying voltage to the Krait CPUs.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/arm/msm/qcom,saw2.txt      | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> new file mode 100644
> index 0000000..1505fb8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> @@ -0,0 +1,35 @@
> +SPM AVS Wrapper 2 (SAW2)
> +
> +The SAW2 is a wrapper around the Subsystem Power Manager (SPM) and the
> +Adaptive Voltage Scaling (AVS) hardware. The SPM is a programmable
> +micro-controller that transitions a piece of hardware (like a processor or
> +subsystem) into and out of low power modes via a direct connection to
> +the PMIC. It can also be wired up to interact with other processors in the
> +system, notifying them when a low power state is entered or exited.
> +
> +PROPERTIES
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: shall contain "qcom,saw2". A more specific value should be
> +		    one of:
> +			 "qcom,saw2-v1"
> +			 "qcom,saw2-v1.1"
> +			 "qcom,saw2-v2"
> +			 "qcom,saw2-v2.1"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: the first element specifies the base address and size of
> +		    the register region. An optional second element specifies
> +		    the base address and size of the alias register region.
> +
> +
> +Example:
> +
> +	regulator@2099000 {
> +		compatible = "qcom,saw2";
> +		reg = <0x02099000 0x1000>, <0x02009000 0x1000>;
> +	};

I have the same general worry as with the ACC regarding the implicit
relationship between CPUs and the registers controlling them, but I
assume that's fine for current implementations, and the binding's so
simple there's nothing preventing future extension.

Acked-By: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
