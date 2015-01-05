Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbbAEPyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:54:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58837 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbbAEPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:53:59 -0500
Date: Mon, 5 Jan 2015 09:52:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Message-ID: <20150105155245.GG19336@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222155936.GB12815@saruman>
 <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
 <20141229161433.GE29379@saruman>
 <CAJ1gpc1yRmuxQVttC5NnKF8PKLeH5PPDkuXU-fwGNcQKRj50Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <CAJ1gpc1yRmuxQVttC5NnKF8PKLeH5PPDkuXU-fwGNcQKRj50Ww@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 04, 2015 at 09:16:01PM +0800, Sneeker Yeh wrote:
> > > Then dwc3 core won't be always created via sub node in platform glue
> > node,
> > > and vendors like us can just drop platform glue which don't have any
> > > specific platform code to wrap dwc3 core, and just directly use dwc3 =
core
> > > via device tree.
> >
> > If your core is really just xhci, why don't just use xhci-plat.c
> >
>=20
> I've tried using xhci-plat.c, but our controller won't work today in
> 3.19-rc1.
> Seems I still need the dwc3 initialization code.

probably missing PHY initialization, that should be easy to patch on
xhci-plat.c

> > directly ? You don't need dwc3 at all. In any case, I refrain from
> > allowing people to use dwc3.ko directly because that has bitten me in
> > the past with MUSB, so sorry but I'll always force people to use the
> > glue layer as that helps me keep dwc3 clean of platform-specific
> > details.
> >
> > > Of course here dwc3 core won't process clock if he got null one, so t=
his
> > > won't affect other vendor's platform which only pass clock phandle to
> > their
> > > dwc3 platform glue driver.
> >
> > right
> >
> > > Just wondering if it's better to write a platform glue only did clock
> > > on/off, or to do the same improvement people ever did for
> > > ehci-platform driver and just drop this platform glue driver?
> >
> > I'll always the sour taste in my mouth due to MUSB. The thing is a
> > complete mess of platform-specific hacks all over the place.
> >
> >
> Super thanks for sharing this, for me it's quite an honor to know that
> story behond.
> and I'll take these suggestion here to revise our platform glue layer.

hey, no problem. Cheers

--=20
balbi

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqrNNAAoJEIaOsuA1yqREYwsP/Rj0fcW/ZQvprAcbaMh1UFuX
qjwcarUHOfvX5JGONF4LVmVEObLu2n4gr3NI0Fot3xj4iTh/12K9B+VyyAFuiTiu
DyS6PtkYqqAIevCZt5gOjHARdbGeQjLTxwj1pEOfPcmgLXmIaHx8A953b4hAOhiI
IcoZMaqjd0u2+DE25BgA9PkjELb3XMXTSinD62YdMbhA+nIKi9ZiTvelbY76AKko
xrK7yTpmQQuO77DIPV6I/nlwsnH6uXwRpbjqxhE5eK6qpi5168WYdaodAzshe6aZ
X6lbfmpynwvHOYXV5zA6yDxxZd6pJhyMIyeRRmfXS20NhnwOjPd4Fm2MBMipPuyF
Ba5A09v/pBEnZNgGVWeTXaGO1HSm3j8+1gXFUc00tc75tmwVCCmgf9WnGXJliVNS
nb2XW1yhSBNVotidQ4qycSSFXHlSeZXf6WVSgYf1d6ADDSN4tk7+5TK+9JrUJ+6h
wBTb51H2P3eL5iJSUwkI84dkYRiDxXY+CU5VHgL9juGNWBYE7+znEogC5Jol7VrO
J5bGeXGPjppLRLG8V6noVGxadvds9DPddQDxrUrILK5IWH2JZtDx6pm+dmg8S11i
g93Axu+1E3oKaB06ZNyM8EZ3hUkze0TUw6UFwzIRw0BQLCOORZqGYoUvYhI3YISe
303WPgElwHvYqBx7UvW2
=LJMQ
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
