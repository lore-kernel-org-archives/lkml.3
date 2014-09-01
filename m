Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaIANsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:48:13 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:42676 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaIANsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:48:10 -0400
Date: Mon, 1 Sep 2014 15:41:48 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr, andrew@lunn.ch,
        jsarha@ti.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        alsa-devel@alsa-project.org, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCHv1 4/7] ASoC: dts: kirkwood-t5325: To support simple card
 newest style.
Message-ID: <20140901134148.GB11312@lunn.ch>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
 <1409545781-20530-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409545781-20530-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:29:38PM +0800, Xiubo Li wrote:
> This patch depends on the following simple card patch:
> ===
> ASoC: simple-card: Merge single and muti DAI link code.

Saying what a patch depends on, is not the best of ChangeLog.

Say something like:

The simple-card binding has been changed, so that a dai-link subnode
is now required, and the properties directly under the sound node are
no longer allowed. Modify the DT to fit this new binding.

   Andrew


> 
> This patch merge single DAI link and muti-DAI links code together,
> and simply the simple-card driver code.
> 
> And also do some other improvement:
> 
> Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
> mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
> frame clock is as master/slave.
> 
> So these same DAI formats should be informed to CPU and CODE DAIs at
> the same time. For the Codec driver will set the bit clock and frame
> clock as the DAI formats said, but for the CPU driver, if the the
> bit clock or frame clock is as Codec master, so it should be set CPU
> DAI device as bit clock or frame clock as slave, and vice versa.
> 
> The old code will cause confusion, and we should be clear that the
> letter 'C' here mean to Codec.
> ===
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/boot/dts/kirkwood-t5325.dts | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts b/arch/arm/boot/dts/kirkwood-t5325.dts
> index 610ec0f..25d1223 100644
> --- a/arch/arm/boot/dts/kirkwood-t5325.dts
> +++ b/arch/arm/boot/dts/kirkwood-t5325.dts
> @@ -189,7 +189,6 @@
>  
>  	sound {
>  		compatible = "simple-audio-card";
> -		simple-audio-card,format = "i2s";
>  		simple-audio-card,routing =
>  			"Headphone Jack", "HPL",
>  			"Headphone Jack", "HPR",
> @@ -204,12 +203,14 @@
>  
>  		simple-audio-card,mclk-fs = <256>;
>  
> -		simple-audio-card,cpu {
> -			sound-dai = <&audio>;
> -		};
> -
> -		simple-audio-card,codec {
> -			sound-dai = <&alc5621>;
> +		simple-audio-card,dai-link {
> +			format = "i2s";
> +			cpu {
> +				sound-dai = <&audio>;
> +			};
> +			codec {
> +				sound-dai = <&alc5621>;
> +			};
>  		};
>  	};
>  };
> -- 
> 1.8.4
> 
