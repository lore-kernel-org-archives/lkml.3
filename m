Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbaAaWRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:17:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59170 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbaAaWRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:17:35 -0500
Date: Fri, 31 Jan 2014 16:15:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Message-ID: <20140131221553.GF2502@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
 <20140131151955.GB20736@saruman.home>
 <52EBC499.2070302@ti.com>
 <20140131154721.GD20736@saruman.home>
 <52EBC650.50305@ti.com>
 <20140131164534.GL20736@saruman.home>
 <52EBF790.3090407@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Content-Disposition: inline
In-Reply-To: <52EBF790.3090407@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 31, 2014 at 02:20:48PM -0500, Santosh Shilimkar wrote:

[ snip ]

> > note that because of pm_runtime_set_active() that first
> > pm_runtime_get_sync() in probe() will simply increase the reference
> > counter without calling my ->runtime_resume() callback, which is exactly
> > what we want, as that would completely avoid situations of bad context
> > being restored because of that initial pm_runtime_get_sync().
> >=20
> Thanks for making your point bit clear.=20

no problem.

> > Then, we can even make pm_runtime completely async easily, because
> > clk_prepare() was called only on probe() (or before it, for that
> > matter).
> >=20
> > Bottomline is, if you can guarantee me that clk_get(), clk_prepare(),
> > clk_enable() and pm_runtime_set_active() will be called properly before
> > my probe, i'll be more than happy to comply with your request above as
> > that will greatly simplify my driver.
> >=20
> Which is the case at least I see on Keystone. And hence the patch from

I was going over pm_domain.c and drivers/base/power/clock_ops.c and none
of them enable pm_runtime or make sure pm_runtime_set_active() is
called.

> Grygorii works. I also noticed your proposal for wider platform to
> enforce above behavior which seems to be a good idea.

it'll take months to stabilize though ;-)

> > Just make, also, that if this clock is shared between dwc3-keystone
> > wrapper and dwc3 core, you clk_get() on both driver's probe.
> >=20
> I understand. In summary, whichever patch you pick(yours) or Grygorii's,
> its completely safe to remove the clock handling from Keystone USB driver.

alright, since I can't really test, I'll take this as a true statement.
If there are any regressions I can blame you, hehehe.

cheers

--=20
balbi

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS7CCZAAoJEIaOsuA1yqREWzIP/18EKF/I3OSuVM1nxTrdsgyA
v5yyE/zX004AI5q0uKehBvi5YxcmiE9mfGmT8V/W39ajgbG1jFZhLURcBOsKdlgI
LmLgwiOlbneKskC0EOhwBMIw6E4cZjKZYx2mZx5hjw5LYTM/u8HL5ehfRPmGBsqQ
CSa3cU5CRCR8rA56oqT5lyGydQPQlQrD0bgPQnl9PhRlBedYZgEB0CLQGglejyBm
kcor61pdEZPX6/Y2XuwVWm7Frcvq2rMivLsiEtkuhiQOBKwIoFscViGVmhDFTrKE
eSJ+LLh1Lpm4HWw3swtH9dpVHVHi9THC+yQqbrNE0PO6QeCPQlZ1Ag3Mt8AX2A9p
5xzovFeR2N1llnN0xxt1Gr/zs0siXbNnIEQlVHlCsQ5VBUaI5oh5AocbGtSXReFg
nLvEqdxe10yeFuTdIzeXuHypBs1/RO4BKsuvSy0a+L4wEyDGR7upMn/pC8ifzwlA
6Mna+Y5SmQW1DkqBAWLFJbvglQJ+1KsQTnoa9Tw3aZYZPcrrsl7KMtQs270LrgMv
JBR6+0zh79g683EP/0EG5POOfdEaMEkT+IASmNRSVO27pB5GGdmEX2GwXc3qKVm3
qfDvg4Khjfw5h+CJYlr7IkNk+n7bbo8sDCOpCwZFyjNbnLT/SFOLEbakwoVuXtyz
YJUOxOqpdtDQnEobrxGs
=06+6
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
