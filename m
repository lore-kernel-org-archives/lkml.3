Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3FRIue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:50:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab3FRIuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:50:32 -0400
Date: Tue, 18 Jun 2013 11:48:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Chao Xie <chao.xie@marvell.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
Message-ID: <20130618084845.GM5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
 <20130618080130.GC5461@arwen.pp.htv.fi>
 <51C0191F.2050104@ti.com>
 <20130618082428.GF5461@arwen.pp.htv.fi>
 <51C01B80.3050803@ti.com>
 <20130618083712.GJ5461@arwen.pp.htv.fi>
 <51C01E11.8050201@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RNRUMt0ZF5Yaq/Aq"
Content-Disposition: inline
In-Reply-To: <51C01E11.8050201@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RNRUMt0ZF5Yaq/Aq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 11:45:05AM +0300, Roger Quadros wrote:
> >>>>> this looks wrong for two reasons:
> >>>>>
> >>>>> a) you're not grabbing the PHY here.
> >>>>>
> >>>>> 	You can't just assume another entity grabbed your PHY for you.
> >>>>
> >>>> Isn't that done in the controller drivers e.g. ehci-fsl.c, ohci-omap=
, etc?
> >>>
> >>> right, and what I'm saying is that it should all be re-factored into
> >>> ehci-hcd core :-)
> >>>
> >>>> If the controllers don't want HCD core to manage the PHY they can ju=
st set it
> >>>> to some error code.
> >>>
> >>> they shouldn't have the choice, otherwise it'll be a bit of a PITA to
> >>> maintain the code. ehci core tries to grab the PHY, if it's not there,
> >>> try to continue anyway. Assume it's not needed.
> >>>
> >>
> >> OK fine, but ehci-omap is a weird case as it needs a slightly different
> >> sequence as to when PHY is initialized depending on which mode it is. =
(Transceiver
> >> or transceiver-less). please see this fix.
> >> http://www.spinics.net/lists/stable/msg12106.html
> >>
> >> All I'm saying as that ehci-omap needs a way to tell hcd core that it =
needs PHY
> >> handling for itself.
> >=20
> > why don't you do that always ? Meaning, why don't you *always* take PHY
> > out of suspend ? If PHY is suspended, you can't wakeup unless you have
> > (in OMAP case) pad wakeup working, right ?
> >=20
>=20
> Maybe I wasn't clear before. This is nothing about wakeup and e always ta=
ke PHY out of suspend.=20
> The problem is when to take it out of suspend relative to when EHCI contr=
oller starts.
> Let me clarify.
>=20
> In Transceiver mode we need this.
>=20
> - bring phy out of reset
> - start EHCI controller
>=20
> Whereas for Transceiver-less mode we need this.
>=20
> - start EHCI controller
> - bring phy out of reset
>=20
> If there is some way to signal this behaviour to the HCD core, it
> should be good enough.

alright, now I get it. That's quite messed up that it has to be this way
:-p

--=20
balbi

--RNRUMt0ZF5Yaq/Aq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwB7sAAoJEIaOsuA1yqREGvgQAIQlpsFmPXqry0lhbtGXCCvI
MGhYu3uimoacj1pUMlcwan/H3JPg4FDRPqeS741qA1wnEYJxf2e56hraCcCSGvHc
hCjt/vqDmuf+bTWZOU/0Wu9MZvE6DczwHvsMUpGMHJwr5nRS+DlufxgcQY2jDxI7
FtxYiliQcKjZKXeqYsXrGNm8UFk889WJfWfZB5uf+80C8y3AxJSQWaLtefhkAz9u
G/2zr9TIHSps4lSc0kXWQqfm3C5TwgR9DEGZQY1tEKNQoYVq2FAS5xQPV1O4qm+i
GOSkQxn/uGiFSu7tPsGgzlrQA3ow4OT4x+PQNRgxbpXdOYpy4AM6/nLLd2ZegZnu
IVXg19zjOKWzeqF7Jv3SRP89jLyiO0dYsS0oIrc7/I86Aon9r1fXSFCAlzkqZIlj
JgNMcxCWdEkXN0qmSIkScxlREzDZpzDCqc7A6tYkDkX7fGgqeT6hQoFOQEyrD/Bx
Vta0jCdP9k+mkJ0utBrTn/wKSEmfL8QxQyoI2CuMPl/TfmcKm87iT0Sxiu5Nf0J1
TUdq4GRejJ+jhuLCO4lnTBjdFE/ljDtmKfiqGv3XGOHUuO2anh3CBTBZ5k1o9j7A
i5KyUkEJ9Jf2Kr7AcXPcN2f5DGcXDUy6PUZZVydzfp/jvsey3jlToCjZ+qcXPJsH
L9RluSxVuf0f7qB6quxE
=Mlcl
-----END PGP SIGNATURE-----

--RNRUMt0ZF5Yaq/Aq--
