Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaHRO3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:29:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40255 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbaHRO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:29:47 -0400
Date: Mon, 18 Aug 2014 15:29:45 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v3 2/2] mfd: arizona: Update DT binding to
	support INn_MODE init_data
Message-ID: <20140818142945.GD7556@opensource.wolfsonmicro.com>
References: <20140818200009.12a52dfa@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818200009.12a52dfa@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:00:09PM +0900, Inha Song wrote:
> This patch update DT binding to support INn_MODE init_data. Each
> input signal path can be configurated either as a Analogue or
> Digital using the INn_MODE registers.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 5c7e723..0064b21 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,14 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - wlf,inmode : A list of INn_MODE register values, where n is the number
> +    of input signals. Each input signal path can be configurated either as a
> +    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE

I would replace the second sentence here with something like
"Valid values are 0 (Differential), 1 (Single-ended) and 2 (Digital
Microphone)."

Thanks,
Charles

> +    registers set to 0 by default. If present, values must be specified less
> +    than or equal to the number of input singals. If values less than the
> +    number of input signals, elements that has not been specifed are set to 0
> +    by default.
> +
>    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
>      they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt
> -- 
> 2.0.0.390.gcb682f8
> 
