Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaE0LuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:50:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43707 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE0LuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:50:05 -0400
Date: Tue, 27 May 2014 12:49:58 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Alex Elder <elder@linaro.org>
Cc: "mporter@linaro.org" <mporter@linaro.org>,
        "bcm@fixthebug.org" <bcm@fixthebug.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rvaswani@codeaurora.org" <rvaswani@codeaurora.org>
Subject: Re: [PATCH v4 1/5] devicetree: bindings: document Broadcom CPU
 enable method
Message-ID: <20140527114958.GC18476@e102568-lin.cambridge.arm.com>
References: <1400607830-10989-1-git-send-email-elder@linaro.org>
 <1400607830-10989-2-git-send-email-elder@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1400607830-10989-2-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 27 May 2014 11:49:59.0401 (UTC) FILETIME=[C97AFD90:01CF79A1]
X-MC-Unique: 114052712500201801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:43:46PM +0100, Alex Elder wrote:
> Broadcom mobile SoCs use a ROM-implemented holding pen for
> controlled boot of secondary cores.  A special register is
> used to communicate to the ROM that a secondary core should
> start executing kernel code.  This enable method is currently
> used for members of the bcm281xx and bcm21664 SoC families.
> 
> The use of an enable method also allows the SMP operation vector to
> be assigned as a result of device tree content for these SoCs.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

This is getting out of control, it is absolutely ghastly. I wonder how
I can manage to keep cpus.txt updated if anyone with a boot method
du jour adds into cpus.txt, and honestly in this specific case it is even
hard to understand why.

Can't it be done with bindings for the relative register address space
(regmap ?) and platform code just calls the registers driver to set-up the
jump address ? It is platform specific code anyway there is no way you
can make this generic.

I really do not see the point in cluttering cpus.txt with this stuff, it
is a platform specific hack, and do not belong in generic bindings in my
opinion.

Thanks,
Lorenzo

> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 333f4ae..c6a2411 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -185,6 +185,7 @@ nodes to be present and contain the properties described below.
>  			    "qcom,gcc-msm8660"
>  			    "qcom,kpss-acc-v1"
>  			    "qcom,kpss-acc-v2"
> +			    "brcm,bcm11351-cpu-method"
>  
>  	- cpu-release-addr
>  		Usage: required for systems that have an "enable-method"
> @@ -209,6 +210,17 @@ nodes to be present and contain the properties described below.
>  		Value type: <phandle>
>  		Definition: Specifies the ACC[2] node associated with this CPU.
>  
> +	- secondary-boot-reg
> +		Usage:
> +			Required for systems that have an "enable-method"
> +			property value of "brcm,bcm11351-cpu-method".
> +		Value type: <u32>
> +		Definition:
> +			Specifies the physical address of the register used to
> +			request the ROM holding pen code release a secondary
> +			CPU.  The value written to the register is formed by
> +			encoding the target CPU id into the low bits of the
> +			physical start address it should jump to.
>  
>  Example 1 (dual-cluster big.LITTLE system 32-bit):
>  
> -- 
> 1.9.1
> 
> 

