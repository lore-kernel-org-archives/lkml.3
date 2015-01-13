Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbbAMJX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:23:29 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:13571 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbbAMJX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:23:26 -0500
Date: Tue, 13 Jan 2015 10:24:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI
 transmitter
Message-ID: <20150113102455.4f29cff5@armhf>
In-Reply-To: <54B0123C.9070800@arm.com>
References: <cover.1420628786.git.moinejf@free.fr>
	<23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
	<54B0123C.9070800@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2015 17:39:08 +0000
Andrew Jackson <Andrew.Jackson@arm.com> wrote:

> > +       snd_pcm_hw_constraint_minmax(runtime,
> > +                               SNDRV_PCM_HW_PARAM_CHANNELS,
> > +                               1, sad[SAD_MX_CHAN_I]);  
> 
> In the light of our discussions elsewhere [1], shouldn't this
> be constrained by the number of hardware channels that the TDA998x
> supports too?  That is, the maximum number of channels should
> be the lesser of sd[SAD_MX_CHAN_I] and number_of_I2S channels 
> (or S/PDIF channels if so configured).

snd_pcm_hw_constraint_minmax() does the job from the min/max numbers of
channels in the DAI definition and the real max number of channels will
be set from audio ports declared in the DT.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
