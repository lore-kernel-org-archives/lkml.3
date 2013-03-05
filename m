Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3CEKCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:02:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:59704 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3CEKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:02:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="asc'?scan'208";a="264510214"
Message-ID: <1362477768.8626.14.camel@jtkirshe-mobl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Tue, 05 Mar 2013 02:02:48 -0800
In-Reply-To: <20130305095821.GC4881@pd.tnic>
References: <2293454.v8QRHr8txR@vostro.rjw.lan>
	 <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic>
	 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
	 <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>
	 <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic>
	 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
	 <5135BDF9.3080102@suse.cz> <20130305095821.GC4881@pd.tnic>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ODsrmgoae+LuCfRcBvqh"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ODsrmgoae+LuCfRcBvqh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-05 at 10:58 +0100, Borislav Petkov wrote:
> On Tue, Mar 05, 2013 at 10:42:17AM +0100, Jiri Slaby wrote:
> > On 03/05/2013 01:16 AM, Bjorn Helgaas wrote:
> > > [+cc e1000-devel, Jeff, Bruce]
> > >=20
> > > On Mon, Mar 4, 2013 at 2:50 PM, Borislav Petkov <bp@alien8.de> wrote:
> > >> On Fri, Feb 15, 2013 at 10:16:41AM +0100, Borislav Petkov wrote:
> > >>> So it looks Bjorn has taken most of them and the e1000e one will go
> > >>> through the e1000e maintainers. I'll test after the merge window is
> > >>> done.
> > >>
> > >> Issue still persists on 3.9-rc1 :-( :
> > >>
> > >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412541] e1000e: eth0 NIC Link =
is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> > >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412554] e1000e 0000:00:19.0 et=
h0: 10/100 speed: disabling TSO
> > >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034158] Uhhuh. NMI received fo=
r unknown reason 2c on CPU 0.
> > >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034166] Do you have a strange =
power saving mode enabled?
> > >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034168] Dazed and confused, bu=
t trying to continue
> > >=20
> > > The e1000e changes didn't get merged, did they?  I don't see the
> > > following changes mentioned at https://lkml.org/lkml/2013/2/4/185 in
> > > 3.9-rc1:
> > >=20
> > >       e1000e: fix pci-device enable-counter balance
> > >       e1000e: fix runtime power management transitions
> > >       e1000e: fix accessing to suspended device
> >=20
> > You're right. They are not even in -next :(.
>=20
> Oh, and there's another issue with this driver I reported yesterday:
> http://marc.info/?l=3Dlinux-kernel&m=3D136243374114892&w=3D2:
>=20
> "Trying to free already-free IRQ 20"
>=20
> which happens during suspend so it seems also related.
>=20
> Rafael, what's the state of those patches here:
> https://lkml.org/lkml/2013/2/4/185, are they ready to be tested or you
> still have issues with them?

They are in my queue of e1000e patches for net and are being testing
currently.  I should be able to push them upstream this week.

--=-ODsrmgoae+LuCfRcBvqh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNcLIAAoJEOVv75VaS+3OcwEP/RpVBavsQvkaC8YeRE2E/Svc
yOJMVTPumT0g5LGsLhcxJsJrNcQcs1NK4j/3hdWJskPb+M3uBhBtRdcWy7bvhKLc
8VLNdqAnBUbQSv0r0RpnljUS2IaRL5vaMlPlXip3M6z8JxXCbn/zCyEdI/Yl/guU
Bp7p4HVl5hoI1jSZudkFxWU/DE3fHG8zGJ0ppV48JxBv/TQmjHw5EVsy+5ZqpaoO
vjzY9lW7v6KLn3dFummQhKrIrEJXCjiCA5ZA2TqHCPaaxYtJJacV011D2VGf7X0G
ai53//R/7Ijrkl6/dBbhHSr3noMzUysxwSRgMOQIumgoSt4/ktTWeAKfD48OYkwX
BruTph+ibWZhlPuuDAQPEKSp5NfvDFmRXJt7WMVoU5B5NPfloQoMrnaWPE5vL83w
0a4GHL7hIiGbBR/4Ptc4Ft3byYYm4JRFGLKcDD3JQz0v21/HVgYCE53RRPCJSL+R
LDVltGFkzqv9W0I0A3BQUPamoIzO5Htz0LSVacWdB5acOAYy2Q+gz2i+oS71I5Xn
F+rFefZ5j7+mMp2yZrw/JMnKJVW6IPwIe8iYwkmjRh0byBQKubEv5bJL4bWMhBFU
IECtTIRnzc4v5RGrvNJA8W9R9cBlYvEl6H6nf2/lkhX1xkVRo+thsTxkWvNlH0HR
UfkJw+MlnO+Ta7IZkE9W
=Ak0c
-----END PGP SIGNATURE-----

--=-ODsrmgoae+LuCfRcBvqh--

