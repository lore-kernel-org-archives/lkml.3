Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3HCNwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:52:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40072 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3HCNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:52:04 -0400
Date: Sat, 3 Aug 2013 14:51:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ASoc: kirkwood: add DT support
Message-ID: <20130803135150.GA23006@n2100.arm.linux.org.uk>
References: <20130731081832.54212b76@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731081832.54212b76@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:18:32AM +0200, Jean-Francois Moine wrote:
> The kirkwood audio driver is used without DT in the Kirkwood machine.
> This patch adds a DT compatible definition for use in other Marvell
> machines such as the Armada 88AP510 (Dove).
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  sound/soc/kirkwood/kirkwood-i2s.c        | 27 ++++++++++++++++------
>  1 file changed, 20 insertions(+), 7 deletions(-)

This misses documentation for the DT conversion.  Documentation should be
created at the same time as a driver is converted.  I think you should
combine patches 3 and 4 together given that you add the documentation and
change the DT compatible name you've given this driver in this patch in
patch 4.
> 
> diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
> index a13fffb..234b5a1 100644
> --- a/sound/soc/kirkwood/kirkwood-i2s.c
> +++ b/sound/soc/kirkwood/kirkwood-i2s.c
> @@ -12,7 +12,6 @@
>  
>  #include <linux/init.h>
>  #include <linux/module.h>
> -#include <linux/platform_device.h>

Why are you getting rid of this include?  It still makes use of platform
devices and the like, so it _should_ continue to include this.  Don't
rely on implicit includes.
