Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaJBShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:37:06 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:16182 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaJBShD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:37:03 -0400
Date: Thu, 2 Oct 2014 20:37:10 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
Message-ID: <20141002203710.03e035f1@armhf>
In-Reply-To: <542C0A2C.6010802@ti.com>
References: <cover.1411547014.git.moinejf@free.fr>
 <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
 <542C0A2C.6010802@ti.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014 17:05:32 +0300
Jyri Sarha <jsarha@ti.com> wrote:

> >   	case AFMT_I2S:
>  >   		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
>  >   		clksel_aip = AIP_CLKSEL_AIP_I2S;
>  >   		clksel_fs = AIP_CLKSEL_FS_ACLK;
>  > -		cts_n = CTS_N_M(3) | CTS_N_K(3);
>  > +
>  > +		/* with I2S input, the CTS_N predivider depends on
>  > +		 * the sample width */
>  > +		switch (priv->audio_sample_format) {
>  > +		case SNDRV_PCM_FORMAT_S16_LE:
>  > +			cts_n = CTS_N_M(3) | CTS_N_K(1);
>  > +			break;
>  > +		case SNDRV_PCM_FORMAT_S24_LE:
>  > +			cts_n = CTS_N_M(3) | CTS_N_K(2);
>  > +			break;
>  > +		default:  
> 
> Setting the default here does not really help, because
> priv->audio_sample_format is initialized to SNDRV_PCM_FORMAT_S24_LE in
> tda998x_encoder_set_config(). But I am Ok with the default being
> changed for 24 bit samples on i2s interface.
> 
>  > +		case SNDRV_PCM_FORMAT_S32_LE:
>  > +			cts_n = CTS_N_M(3) | CTS_N_K(3);
>  > +			break;
>  > +		}

I looked again at the original driver and they set K = 1 for 16 bits
and K = 3 for 24 or 32 bits.

Anyway, letting K = 3 for 16 bits works for me, so, I will not change
this code in the next version.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
