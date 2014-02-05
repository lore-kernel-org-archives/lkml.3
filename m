Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaBESHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:07:33 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:50389 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaBESHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:07:30 -0500
Date: Wed, 5 Feb 2014 19:07:32 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw
 parameters from EDID
Message-ID: <20140205190732.5617f200@armhf>
In-Reply-To: <52F2021A.9020804@metafoo.de>
References: <cover.1391274627.git.moinejf@free.fr>
	<1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
	<20140204180625.GM22609@sirena.org.uk>
	<20140205101134.4591e5c3@armhf>
	<52F2021A.9020804@metafoo.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb 2014 10:19:22 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> > So, in the CODEC, I don't see how I could update the parameters
> > dictated by the EDID otherwise in changing the DAI driver parameters.
> >  
> 
> The startup function is the right place. But instead of modifying the DAI 
> use snd_pcm_hw_constraint_mask64(), snd_pcm_hw_constraint_list(), etc. to 
> setup the additional constraints that come from the EDID.

It is more complicated, but it works. Nevertheless, I have 2 problems:

- snd_pcm_hw_constraint_list() keeps a pointer to the list, so, it
  cannot be in the stack. It fix this with static struct and rate array.

- snd_pcm_hw_constraint_mask64() is not exported.
  Is there an other way to set constraints on the formats/sample widths?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
