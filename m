Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbbAERKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:10:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37509 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbAERKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:10:37 -0500
Date: Mon, 5 Jan 2015 11:09:21 -0600
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
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
Message-ID: <20150105170921.GH19336@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222153730.GA12815@saruman>
 <CAJ1gpc3jVpz=5ME4+wCJDW5NKihvB4xYzwi0co=UuPtG9Ubmjg@mail.gmail.com>
 <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
 <20141229160641.GD29379@saruman>
 <CAJ1gpc0Uu4vS2iA_o_W5NaE_QBWDYFZJio7yKvhpaR5f=qWcGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KscVNZbUup0vZz0f"
Content-Disposition: inline
In-Reply-To: <CAJ1gpc0Uu4vS2iA_o_W5NaE_QBWDYFZJio7yKvhpaR5f=qWcGA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KscVNZbUup0vZz0f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 04, 2015 at 08:55:01PM +0800, Sneeker Yeh wrote:
> > > So far Fujitsu Semiconductor got Synopsys internal case id , that is "
> > > Case: 8000679552".
> > > However the contents belongs this id cannot be referred except Fujitsu
> > > Semiconductor and Synopsys.
> > > Synopsis decide the official errata (STAR information) will be disclo=
sed
> > > next February.
> > >
> > > Would you suggest if this quirk can be accepted with this case ID, or=
 can
> > > only be accepted with STARS ticket number?
> >
> > The thing is that without the STARS number I can't really verify which
> > versions of the IP would be affected. Clearly, it's not only your setup
> > and I think it's pretty unfair to have "is_compatible("fujitsu")" to
> >
>=20
> just found some way of quirk injection i miss,
> does it looks more reasonable if i have to decide to use it via Kconfig? :
> 20f6fdd01c2c0de9cc1109083222edded24c5350
> b2f463e1300016785d63475c56f5807e2be00934

We will only use Kconfig for those which can't be detected in runtime.
LPM is one such case as there's no way for SW to detect that core was
configured with LPM Errata, IIRC.

> > enable the quirk only for you. Isn't there a better way of enabling the
> > quirk based off of revision detection couple with a look on GHWPARAMS*
> > registers ?
> >
> > What's tricking me is this claim that only config-free PHYs would be
> > affected, why ?
> >
>=20
> i'm still struggling now to try to get more information about this.
> some security policy inside Fujitsu make me unable to access full
> information of this errata today.
>=20
> Someday after i get enough information,
> i shall take your suggestion here that seems better to incur quirk
> dynamically via GHWPARAMS,
> and then send it here again.

ok, hopefully you'll find a way ;-)

--=20
balbi

--KscVNZbUup0vZz0f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqsVBAAoJEIaOsuA1yqREKv0P/Ru1Q/EYlXFalvHJeVmouThA
tBV5RQXIQVBgUYnSKgFmr8dDfSEmY4hw/M3QTEA/v9aHzUBCSzcIWPda4dXrSrI2
i0edd3jGppso9Of5W/v8ruXP5eXIiGOuBCgZ/n2Ew1o16cOArwUu2taSrnBhEvkD
77rBEclp6S4TmtME5TXl+xRpc9zfRd+NMCRKrJU4zh2N3Ny667x7fwHdax3GBoQ2
wctUul5EiWFG3/axEzLiKGs4DPXpbeuOMOCuQdnwnCW03GVoiCM/Z5iJHSO0vyUv
jpD4pAX68KIeHE6hAqblgxNpkJwMmT6239pRyeHDNyXkx7U5jQGwdBmoYK5k6Wyt
ILbax5mWhxi4sLAPOaot2WJjvEcaNYZxMkSDfDTm18arh9qWnwpOVvJ7sClfC5vE
NNJuSAJ65nbtvZB8utVfbB4/PsJ/mOSG9iYNalAVjS6eFQkU9qr3mIpgCX5FaGh+
AJ2k/7MezmiRI1F4IcBrzsfCn32f7mPb4dN3lLQiXqfsSNYBnF27gB1JwzvEa1v4
Yy4MJtsGr+Aj2XJYJKF42JWofK9nbP2IjRc0PqCT6kc2heA2i4se1cFtX/Qi5fWh
XL23pM1mg12nnKdZ/ZmeACY1KrcfFTGyRycWo1kOY9KEXlC1uXWKrwkpA3M67TQe
bG9cNDvCrlUKE8l/pCcS
=S/CV
-----END PGP SIGNATURE-----

--KscVNZbUup0vZz0f--
