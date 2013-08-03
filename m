Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab3HCNtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:49:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40063 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3HCNtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:49:15 -0400
Date: Sat, 3 Aug 2013 14:48:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ASoC: kirkwood: change kirkwood-i2s to
	mvebu-pcm-audio and DT doc
Message-ID: <20130803134855.GZ23006@n2100.arm.linux.org.uk>
References: <20130731081858.53413597@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731081858.53413597@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:18:58AM +0200, Jean-Francois Moine wrote:
> diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
> index 9844010..4f817a2 100644
> --- a/sound/soc/kirkwood/kirkwood-i2s.c
> +++ b/sound/soc/kirkwood/kirkwood-i2s.c
> @@ -25,7 +25,7 @@
>  
>  #include "kirkwood.h"
>  
> -#define DRV_NAME	"kirkwood-i2s"
> +#define DRV_NAME	"mvebu-pcm-audio"

This breaks non-DT users of this driver.  The device in arch/arm/mach-kirkwood
is left as "kirkwood-i2s" but the platform device is now called something
different.

>  static struct of_device_id kirkwood_i2s_of_match[] = {
> -	{ .compatible = "marvell,kirkwood-i2s" },
> +	{ .compatible = "marvell,mvebu-pcm-audio" },

You've only just introduced "marvell,kirkwood-i2s" in the previous patch.
Why introduce something and then immediately change its name?  This makes
no sense what so ever.
