Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbbANVq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:46:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48381 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbANVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:46:56 -0500
Date: Wed, 14 Jan 2015 15:46:03 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Robert Baldyga <r.baldyga@samsung.com>,
        <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dinguyen@opensource.altera.com>, <yousaf.kaukab@intel.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Message-ID: <20150114214603.GU16533@saruman>
Reply-To: <balbi@ti.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vXO+wElmrbrjQnTC"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vXO+wElmrbrjQnTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 04:41:23PM -0500, Alan Stern wrote:
> > > > This is really, really odd. Register accesses are atomic, so the lo=
ck
> > > > isn't really doing anything. Besides, you're calling
> > > > dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
> > > > already disabled.
> > >=20
> > > Spinlocks sometimes do more than you think.  For instance, here the=
=20
> > > lock prevents the register access from happening while some other CPU=
=20
> > > is holding the lock.  If a silicon quirk causes the register access t=
o=20
> > > interfere with other activities, this could be important.
> >=20
> > readl() (which is used by dwc2_is_controller_alive()) adds a memory
> > barrier to the register accesses, that should force all register
> > accesses the be correctly ordered.
>=20
> Memory barriers will order accesses that are all made on the same CPU
> with respect to each other.  They do not order these accesses against
> accesses made from another CPU -- that's why we have spinlocks.  :-)

a fair point :-) The register is still read-only, so that shouldn't
matter either :-)

> >  I fail to see how a silicon quirk
> > could cause this and if, indeed, it does, I'd be more comfortable with a
> > proper STARS tickect number from synopsys :-s
>=20
> Maybe accessing this register somehow resets something else.  I don't
> know.  It seems unlikely, but at least it explains how adding a
> spinlock could fix the problem.

I would really need Paul (or someone at Synopsys) to confirm this
somehow. Maybe it has something to do with how the register is
implemented, dunno.

Paul, do you have any idea what could cause this ? Could the HW into
some weird state if we read GSNPSID at random locations or when data is
being transferred, or anything like that ?

--=20
balbi

--vXO+wElmrbrjQnTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtuObAAoJEIaOsuA1yqREzlwP/1yhVgVjd53NoXBYZCSPe/JB
ajZzYKrVNgGWdTn4IHhoBbdwOh7MJeKpWPa+ta+iP5T/mdoao1xQ92/p+Q1Wn2bn
njhtGH5xXAk5mIjATka/jFbtPANdd5PMB0nRtbUUiCHplIvOZvas6yjGaN5pnAkS
20DEVRb8THZHP0+3QBducr8XEyALdhk7bNPtTsP1+hHV00VZRupzaS4AAP7zXVZ8
m8itrzXAdfkoeDhGmXm7n1kIyx4m1KhyRMcsYmjh2B1uMKUCEOxrk1tKopmSLqXG
oc0tW0EJF2R53WHuYtDdK6poQsbijydmTvX9Me0Kw/XldAWTmrJuboGbWK0VJBAH
G4gC3NaHO5cvCfpa/BETCZ0yLWwkp5+8s/KBY0vLeMiPfmXVOXiWkKTLwxhiN31X
n9Wkeby/GsCfBb72iYzPT5o5ivTc67Qi6fiC9yxyerwaF6vzROI3k8xXmwhSYkTI
tWpn+jg/PhWq9znnVFPDPxSN/ldGBpeHjNK5ZjxExQNTRPEgG3jva7UI/k76oXiI
CyDDa3l2JO/rjl2jkPkRCpC095cNOqaauy+/GAp+f9+fW+O7lCvhM09QDeJOF1aF
bq4gdn5XrWoLC0JdEmPXSi9vbgrjJclkGx1v8GMH/O6eWTHTx0O3KosVddzmXHXg
NJHYHEf53UKxyri//++p
=fZ4P
-----END PGP SIGNATURE-----

--vXO+wElmrbrjQnTC--
