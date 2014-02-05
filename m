Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaBEJLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:11:10 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41767 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaBEJLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:11:07 -0500
Date: Wed, 5 Feb 2014 10:11:34 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw parameters
 from EDID
Message-ID: <20140205101134.4591e5c3@armhf>
In-Reply-To: <20140204180625.GM22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
	<1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
	<20140204180625.GM22609@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 18:06:25 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Jan 27, 2014 at 09:48:54AM +0100, Jean-Francois Moine wrote:
> 
> > +		/* change the snd_soc_pcm_stream values of the driver */
> > +		stream->rates = rate_mask;
> > +		stream->channels_max = max_channels;
> > +		stream->formats = formats;
> 
> > +	/* copy the DAI driver to a writable area */
> > +	dai_drv = devm_kzalloc(&pdev->dev, sizeof(tda998x_dai), GFP_KERNEL);
> > +	if (!dai_drv)
> > +		return -ENOMEM;
> > +	memcpy(dai_drv, tda998x_dai, sizeof(tda998x_dai));
> > +
> 
> The code should be doing this by setting constraints based on the
> current setup rather than by editing the data structure - the expecation
> is very much that the data won't change so this prevents surprises with
> future work on the core.

As it is done in the soc core, in soc_pcm_open(), the runtime hw_params
are initialized after the call to the CODEC startup, and the next CODEC
event is hw_params() when the user has already chosen all the parameters.

So, in the CODEC, I don't see how I could update the parameters
dictated by the EDID otherwise in changing the DAI driver parameters.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
