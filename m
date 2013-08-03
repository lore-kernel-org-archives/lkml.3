Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3HCQwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:52:11 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:41186 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab3HCQwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:52:09 -0400
Date: Sat, 3 Aug 2013 18:52:55 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
Message-ID: <20130803185255.1b1932c4@armhf>
In-Reply-To: <20130803124652.GY23006@n2100.arm.linux.org.uk>
References: <20130731081739.76aae84c@armhf>
	<20130803124652.GY23006@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Aug 2013 13:46:52 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Jul 31, 2013 at 08:17:39AM +0200, Jean-Francois Moine wrote:
> > The function kirkwood_i2s_dev_remove() may be used when probe fails.
> 
> Looking at this deeper, I'm not happy with this.
	[snip]
> What this means is that if snd_soc_register_component() fails, we end
> up calling snd_soc_unregister_component().  This may be fine with the
> way snd_soc_unregister_component() is currently implemented, but you're
> making the assumption that it's fine to call snd_soc_unregister_component()
> for a device which hasn't been registered.  Technically, this is a
> layering violation, which makes this change fragile if the behaviour
> of snd_soc_unregister_component() changes in the future.
> 
> For the sake of two calls in the error path, I don't think the benefits
> of this patch outweigh the risk.

You are right, but if snd_soc_unregister_component() could be
officially used safely with no previous call to
snd_soc_register_component(), this would simplify error handling in
other drivers too...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
