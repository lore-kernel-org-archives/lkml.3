Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaIOTbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:31:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58567 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbaIOTbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:31:01 -0400
Date: Mon, 15 Sep 2014 14:29:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140915192946.GG20655@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
 <20140911210800.GI18849@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <20140911210800.GI18849@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 11, 2014 at 02:08:01PM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > OMAP INTC irqchip driver will be moved under
> > drivers/irqchip/ soon but we still have a dependency
> > with mach-omap2 when it comes to idle functions.
> >=20
> > In order to make it easy to share those function
> > prototypes with OMAP PM code, we introduce this new
> > header.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-3430sdp.c        |  1 +
> >  arch/arm/mach-omap2/board-am3517crane.c    |  1 +
> >  arch/arm/mach-omap2/board-am3517evm.c      |  1 +
> >  arch/arm/mach-omap2/board-cm-t35.c         |  1 +
> >  arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
> >  arch/arm/mach-omap2/board-devkit8000.c     |  1 +
> >  arch/arm/mach-omap2/board-ldp.c            |  1 +
> >  arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
> >  arch/arm/mach-omap2/board-omap3logic.c     |  1 +
> >  arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
> >  arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
> >  arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
> >  arch/arm/mach-omap2/board-overo.c          |  1 +
> >  arch/arm/mach-omap2/board-rx51.c           |  1 +
> >  arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
> >  arch/arm/mach-omap2/common.h               |  9 ---------
> >  arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
> >  arch/arm/mach-omap2/irq.c                  |  1 +
> >  arch/arm/mach-omap2/pm24xx.c               |  1 +
> >  arch/arm/mach-omap2/pm34xx.c               |  1 +
> >  include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++++++=
++++++++
> >  21 files changed, 51 insertions(+), 9 deletions(-)
>=20
> I ended up setting up another branch without this patch
> at omap-for-v3.12/intc-v2. It now has dependency to the
> SoC changes from Nishant and the const cleanup fix from Uwe.
>=20
> This patch is not needed, let's leave this out, the functions

so, if we don't add that header, we will have to include soc.h and
common.h with full (relative) path from drivers/irqchip/irq-omap-intc.c.
IOW:

#include "../../arch/arm/mach-omap2/common.h"

Neither soc.h nor common.h are part of the include path. I'd rather not
go down that route and just add this extra header. Even if you ask me to
move soc.h and common.h under <asm/mach/{soc,common}.h> we will already
have to modify every board file anyway.

--=20
balbi

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUFz4qAAoJEIaOsuA1yqREHtwP/iAgXgRl3KYou93Tsbap/NZq
dGXQdoV6qOKW/FYb1yTSuQfHgT9eiJ0FWjRZJlMTXQdM1/6ZyUuJj6kJvEAo63wm
Yb4tbWvWNFYKoOksJOcG2F00H+MhS3o61ahuOcTw/wGsOnfA7O5xCBrGS5k12QVw
l7rs7+cZZ8e1/9lerhAQeTVg7JmVN2fJmQqAH/OKN1xuIAxv2rKHYtPEwX7gfsTF
+8j1r6uv3SqKb4VLZbvZhNHioP7Hk7V8ZZsQtXCZUUDog6JrKV+cRJxyCBFgpCvu
14lVlfdGeejZgzpSvPjE5Z3XibpJsvlKayI48tvAcDEBeUVAQQldRUiipn2IobRz
lYofcLQ0akbwvDRcRitQ6Rtz5Cr9XRCg2lE0t5DMiQjpFhIUqTdZyg+pBm/6njMT
3x2Sr763QbhF7dr+iit5UH108eUHLOgS2mG9irVqFb9EM2ZjhOqGk+4g5tpwTrtu
dItEt5zvKxVxBUx9LJ61aHJBQWetsJTkhqAb3rBFSqvYdPDc6v/PM/w4ed18h57Z
Q6RBPZM3K8yDmVU5bJlOXv1eandqhGd3kjA3Cg4KkYrrqKL+ZmY+0i41AHriFhjs
eAl5U4rI1dRH/sSHoQpoZpgVrakz/enjKB6GtKPwjrJ5msmd1b2tcW4a98Mg6JFw
M1+ofiuKfeKfSlxs6IlI
=sjJu
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
