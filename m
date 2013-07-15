Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3GOXEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:04:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36983 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3GOXEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:04:43 -0400
Date: Tue, 16 Jul 2013 00:04:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] ASoC: kirkwood-i2s: fix a compilation warning
Message-ID: <20130715230429.GA24642@n2100.arm.linux.org.uk>
References: <20130715103644.04e57749@armhf> <20130715153101.GK11538@sirena.org.uk> <20130715203756.68abbf10@armhf> <20130715200851.GD11538@sirena.org.uk> <20130715213727.GW24642@n2100.arm.linux.org.uk> <20130715225836.GG11538@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715225836.GG11538@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:58:36PM +0100, Mark Brown wrote:
> The only thing I can see which is pushing a constraint up the stack is
> KIRKWOOD_I2S_RATES in the DAIs which only allows 44.1kHz, 48kHz and
> 96kHz, the rates for which the internal clock is used.

Take a closer look, because you are mistaken.

Particularly note how there are two struct snd_soc_dai_driver's, one
which gets used if we don't have an external clock, and the other
which does.  They differ in their .rates initializer.
