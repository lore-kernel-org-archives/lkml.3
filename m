Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbbAVKww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:52:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:17675 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbbAVKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:52:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,448,1418112000"; 
   d="asc'?scan'208";a="640926179"
Message-ID: <1421923966.2560.30.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
	mode control
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Skidmore, Donald C'" <donald.c.skidmore@intel.com>,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        Hayato Momma <h-momma@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Jan 2015 02:52:46 -0800
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	 <874mrlu18e.fsf@nemi.mork.no>
	 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
	 <F6FB0E698C9B3143BDF729DF222866469129B7F5@ORSMSX110.amr.corp.intel.com>
	 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07F09@BPXM14GP.gisp.nec.co.jp>
	 <F6FB0E698C9B3143BDF729DF222866469129B844@ORSMSX110.amr.corp.intel.com>
	 <7F861DC0615E0C47A872E6F3C5FCDDBD05E08FF6@BPXM14GP.gisp.nec.co.jp>
	 <063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>
	 <7F861DC0615E0C47A872E6F3C5FCDDBD05E090FE@BPXM14GP.gisp.nec.co.jp>
	 <F6FB0E698C9B3143BDF729DF222866469129BC03@ORSMSX110.amr.corp.intel.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IdTBaB5t0ET6dPIfMMBX"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IdTBaB5t0ET6dPIfMMBX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-22 at 09:50 +0000, David Laight wrote:
> From: Skidmore, Donald C=20
> > > > From: Hiroshi Shimamoto
> > > > > My concern is what is the real issue that VF multicast
> promiscuous mode
> > > can cause.
> > > > > I think there is the 4k entries to filter multicast address,
> and the
> > > > > current ixgbe/ixgbevf can turn all bits on from VM. That is
> almost same as
> > > enabling multicast promiscuous mode.
> > > > > I mean that we can receive all multicast addresses by an
> onerous
> > > operation in untrusted VM.
> > > > > I think we should clarify what is real security issue in this
> context.
> > > >
> > > > If you are worried about passing un-enabled multicasts to users
> then
> > > > what about doing a software hash of received multicasts and
> checking
> > > > against an actual list of multicasts enabled for that hash
> entry.
> > > > Under normal conditions there is likely to be only a single
> address to check.
> > > >
> > > > It may (or may not) be best to use the same hash as any hashing
> > > > hardware filter uses.
> > >
> > > thanks for the comment. But I don't think that is the point.
> > >
> > > I guess, introducing VF multicast promiscuous mode seems to add
> new
> > > privilege to peek every multicast packet in VM and that doesn't
> look good.
> > > On the other hand, I think that there has been the same privilege
> in the
> > > current ixgbe/ixgbevf implementation already. Or I'm reading the
> code
> > > wrongly.
> > > I'd like to clarify what is the issue of allowing to receive all
> multicast packets.
> >=20
> > Allowing a VM to give itself the privilege of seeing every multicast
> packet
> > could be seen as a hole in VM isolation.
> > Now if the host system allows this policy I don't see this as an
> issue as
> > someone specifically allowed this to happen and then must not be
> concerned.
> > We could even log that it has occurred, which I believe your patch
> did do.
> > The issue is also further muddied, as you mentioned above, since
> some of
> > these multicast packets are leaking anyway (the HW currently uses a
> 12 bit mask).
> > It's just that this change would greatly enlarge that hole from a
> fraction to
> > all multicast packets.
>=20
> Why does it have anything to do with VM isolation?
> Isn't is just the same as if the VM were connected directly to the
> ethernet cable?

So give an example of when the VF driver is connected directly to the
ethernet cable and a PF driver (ixgbe) does not exist, at least that is
what you are suggesting.

--=-IdTBaB5t0ET6dPIfMMBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUwNZ+AAoJEOVv75VaS+3OCt8P/2rvvVTRA0BOZOM8roh22K93
qv5xQOTKEU8awcpp1akhpL1fCZ6maucb67euJI5lm1BOZ5JrZ3amR+CFE4ChOLYG
/1+JIFG4rm3OXhI72gozoTOaOmz9OokKTU26gFaz6QAvkIresWEQwfXBM4nnuh3C
TLx6lbzvlrOgaj9lvQWacCxUKmbtETyKvWaIyMk/LalM0E/REQLZcqVQX56OSDtA
Bn4TMWPtdINoVT/P+0UsdtNhJ4yC+02rcEggjOhBTNTX/TF7vQt4OrYTajbkZQl/
uIHZKRN+16js55BH0EyWJBqXk9UnLnXOATQa0wCfLN079xyyTjZ4j7MDgtxhGJwW
7ZxEGzeh2rrkir6hQEaF5fJ3QvnEEV6yOZutfir4CBaJfT8BrDIWPedsN7jHFXUw
15jgylZAa2R7H2dNeacccdYp8kz9Xf1T65aIYau3E5JHb5vDeFbMncqMcDaLfs9Q
A7cvkAdGqPFVm56NPW2/HO2eVzY7jSmy9+f/syzEW10bI4hVlg/nnFBW0O2Fa0ah
E2EwZdcabsMpcM/e1ZlV/0qrTVq7QJDvywm4hO6lTgvharQARy03YaQLLrqC7dPm
h4T2l1xaXFxqHxyNaD6KPu0cSm90UkmSzolj28EPCVCWeatwTSyPdtOX4CaQo9ap
QMIDvLN0Ph12sTBFaEC4
=RxGs
-----END PGP SIGNATURE-----

--=-IdTBaB5t0ET6dPIfMMBX--

