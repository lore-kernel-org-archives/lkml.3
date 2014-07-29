Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaG2PiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:38:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaG2PiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:38:06 -0400
Date: Tue, 29 Jul 2014 10:36:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <jason@lakedaemon.net>, <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <bcousson@baylibre.com>, <tglx@linutronix.de>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 13/35] arm: omap: irq: call set_handle_irq() from
 intc_of_init
Message-ID: <20140729153649.GD17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-14-git-send-email-balbi@ti.com>
 <20140729022019.GB4421@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <20140729022019.GB4421@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 04:20:20AM +0200, Sebastian Reichel wrote:
> Hi,
>=20
> On Mon, Jul 28, 2014 at 04:16:01PM -0500, Felipe Balbi wrote:
> > this will let us drop .handle_irq and .init_irq fields
> > from our generic machine_descs.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  arch/arm/mach-omap2/irq.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
> > index e6997c5..e452411 100644
> > --- a/arch/arm/mach-omap2/irq.c
> > +++ b/arch/arm/mach-omap2/irq.c
> > @@ -314,6 +314,8 @@ static int __init intc_of_init(struct device_node *=
node,
> > =20
> >  	omap_init_irq(res.start, nr_irq, of_node_get(node));
> > =20
> > +	set_handle_irq(omap2_intc_handle_irq);
> > +
> >  	return 0;
> >  }
> >
>=20
> if you respin the patchset you may want to call omap_intc_handle_irq
> directly. It makes the review of the patchset less confusing.
>=20
> (I was wondering why omap3 can call omap2_intc_handle_irq until I
> noticed, that your previous changes made both functions simple
> wrapper functions for omap_intc_handle_irq)

this is done later for a reason. At this point, omap_intc_handle_irq()
still misses proper annotations for asmlinkage and
__exception_irq_entry.

--=20
balbi

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT17+RAAoJEIaOsuA1yqREfS8QAI8g/VP1R6GdfUQrv8DYsWOs
oynMlnTbeAOAgPtph4SxhYtS/Egyqqr6CeXZ9aOUNHtuDxdit9VuVoatxK/zAOW2
RFwmBYlreZ0V0vtLSNly+yKSWl8JAem/+s519PFqDaZ3y0f1SxB/0e7Pfu0TCmE6
K37ywb/RTRoOKVp9uKip68VSy52DXYCvLQrjhP+BL7q5+IJJRkQwS6eI4bXREFcY
OZ8BrMB+F5MgLdJRTDGvLY1BSuLJ6pf1jdvmB0nk/NTDPb0Aey9B4gH7+G20Al9j
XyZFzT7yoxku1DAN6P2/LnmS/Qvd8SoC+yXDJIjl8vfDEgU1eonyIfDuDnmMr+LE
P+7aZdJHHvJDzEmXlgfl9VjLIt3bXXB8KYeNXvwUZeCEf/VqlOd4dIFOItAWGSLx
C11OV1l87EPsrsc8EoOP6o5jNYsS79WxhJwCyxqgNrAru2/Aym5X/ajswXhOkYj9
SpQw13SwvTqyE5GLDGfPv2F5t+8MiJ1F7CeBab6s17TZhSCn+60duPiVP0gsC0qq
LhQcsfljVzcX19MntGa2E7qly98lkNKy7Z/1yQd4JEQRLyUIxGeKkrTVCjoxHYeK
6cGbAlsCX6iswnlsozrtMU0wC6NoKHFVB5zdIqdr+rtZpkZs9QZ848TpvwYruAaQ
DgemOK1rZQw+op0o22aD
=F/4v
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
