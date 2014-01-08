Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaAHO0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:26:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51222 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890AbaAHO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:26:10 -0500
Date: Wed, 8 Jan 2014 14:25:41 +0000
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
Subject: Re: [PATCH v2 2/9] devicetree: bindings: Document qcom,kpss-acc
Message-ID: <20140108142541.GK6701@e106331-lin.cambridge.arm.com>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
 <1387845593-10050-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387845593-10050-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:39:46AM +0000, Stephen Boyd wrote:
> The kpss acc binding describes the clock, reset, and power domain
> controller for a Krait CPU.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> new file mode 100644
> index 0000000..1333db9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> @@ -0,0 +1,30 @@
> +Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
> +
> +The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
> +There is one ACC register region per CPU within the KPSS remapped region as
> +well as an alias register region that remaps accesses to the ACC associated
> +with the CPU accessing the region.

Is the mapping of ACC register to a specific processor well-defined? I
assume it's just in order of MPIDR.Aff0.

To maintain our collective sanity in the face of possible future
implementations, do you have an idea as to whether this might need to be
extended in future for multiple clusters / reordered IDs and so on?

I assume we'd just allocate a new compatible string if those get a
little crazy.

> +
> +PROPERTIES
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: should be one of:
> +			"qcom,kpss-acc-v1"
> +			"qcom,kpss-acc-v2"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: the first element specifies the base address and size of
> +		    the register region. An optional second element specifies
> +		    the base address and size of the alias register region.
> +
> +Example:
> +
> +	clock-controller@2088000 {
> +		compatible = "qcom,kpss-acc-v2";
> +		reg = <0x02088000 0x1000>,
> +		      <0x02008000 0x1000>;
> +	};

Otherwise, this looks fine to me.

Mark.
