Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3CRSXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:23:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55558 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3CRSXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:23:43 -0400
Date: Mon, 18 Mar 2013 20:23:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Yuan-Hsin Chen <yuanlmm@gmail.com>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <Julia.Lawall@lip6.fr>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
Message-ID: <20130318182316.GA13371@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130318101854.GQ17135@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1303181010540.1922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1303181010540.1922-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 18, 2013 at 10:16:56AM -0400, Alan Stern wrote:
> > > it would cause copious modification and duplication of ehci hcd
> > > driver. For example, there is no "configured_flag" register in
> > > fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
> > > in function ehci_run which would cause compile errors. Therefore,
> > > maybe my first patch which refers to oxu210hp-hcd is a better
> > > solution?
> >=20
> > why don't you just add a quirk flag to ehci struct so that it knows it
> > shouldn't access CONFIGFLAG register when that's non-existent ?
> >=20
> > There are only 5 uses of configured_flag in ehci-hcd.c, so it should be
> > easy to wrap that around a flag check.
>=20
> Two of those uses turn configured_flag on and two of them turn it off. =
=20
> However, one of the uses tests its value (the first one in
> ehci_resume).  How would that be handled if configured_flag doesn't
> exist?

perhaps they don't use it because they have a root-hub TT ? In that case
you assume EHCI *always* owns the port. Would that work ?

--=20
balbi

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRR1uUAAoJEIaOsuA1yqREHpQQAKoZnQaguYzJ5eI4BxFT33qF
efzNKbbwpBf1oNquTbZ2S3z1BunEB1VO7HESTJ3hGEFXglfqYHg2lHKF6S3FKeDw
LIe+CR7RuirY8xiHw4TLN/4IzSh0JpcedHAxdfjjpz/8t3ZOxY3E+7XFUlCkVKOW
u9dk3fdqgXnORrglRqgGw589qvCRoFq2fbWxmRQN7rxVWlLtbLV0ccYt9NaUlSgs
ny3zGMbWALlOULFzZr+RRAFvAEzFhc2c1YLh6N7sxu0FAPHeKlRYT6PSYCE0Oyt0
Q46inRk+WSzZ8FeqCReIFTG3nXA41jGMQxJFeYxbPsZ88CycOEXOgD/uXtBA9X+F
H2nqr5pk5u5wzmiuXgRo2I4Vt+dOH33PWKSfq5ENq/xlZuEiEzXbag2XIZpiJGY6
9vg2kQ7k9hV7Ui6lc38WfY7gEHdM/CeA/D1APbet+YPj8TRXwJ3tcU35ya0VcS5x
TWaW42ETai4FkOIdLBrZhrB0yZ7eM3qBMWs2R6JV2327SFxwlRU3wGN52/V/bSLg
pkF2aYffD/NFTpH5IbFwRxVdAcyXHmaa2VC4XnOsttSAoGq/j3VV7u30YBLTOgAe
3Rab/P2fHjnrviqXEQwRrkPBDi//z5hg0Lpk6FnL6p9BWCFqUYNvm2JScyXm5H12
vdXn2xM6ShLrEfDhkHr7
=bDzJ
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
