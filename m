Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbbANWlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:41:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbbANWl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:41:29 -0500
Date: Wed, 14 Jan 2015 16:40:35 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Robert Baldyga <r.baldyga@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Message-ID: <20150114224035.GW16533@saruman>
Reply-To: <balbi@ti.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
 <20150114223941.GV16533@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPWyEuR5EuEA2EVk"
Content-Disposition: inline
In-Reply-To: <20150114223941.GV16533@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bPWyEuR5EuEA2EVk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 04:39:41PM -0600, Felipe Balbi wrote:
> On Wed, Jan 14, 2015 at 10:28:54PM +0000, Paul Zimmerman wrote:
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Wednesday, January 14, 2015 1:46 PM
> > >=20
> > > On Wed, Jan 14, 2015 at 04:41:23PM -0500, Alan Stern wrote:
> > > > > > > This is really, really odd. Register accesses are atomic, so =
the lock
> > > > > > > isn't really doing anything. Besides, you're calling
> > > > > > > dwc2_is_controller_alive() from within the IRQ handler, so IR=
Qs are
> > > > > > > already disabled.
> > > > > >
> > > > > > Spinlocks sometimes do more than you think.  For instance, here=
 the
> > > > > > lock prevents the register access from happening while some oth=
er CPU
> > > > > > is holding the lock.  If a silicon quirk causes the register ac=
cess to
> > > > > > interfere with other activities, this could be important.
> > > > >
> > > > > readl() (which is used by dwc2_is_controller_alive()) adds a memo=
ry
> > > > > barrier to the register accesses, that should force all register
> > > > > accesses the be correctly ordered.
> > > >
> > > > Memory barriers will order accesses that are all made on the same C=
PU
> > > > with respect to each other.  They do not order these accesses again=
st
> > > > accesses made from another CPU -- that's why we have spinlocks.  :-)
> > >=20
> > > a fair point :-) The register is still read-only, so that shouldn't
> > > matter either :-)
> > >=20
> > > > >  I fail to see how a silicon quirk
> > > > > could cause this and if, indeed, it does, I'd be more comfortable=
 with a
> > > > > proper STARS tickect number from synopsys :-s
> > > >
> > > > Maybe accessing this register somehow resets something else.  I don=
't
> > > > know.  It seems unlikely, but at least it explains how adding a
> > > > spinlock could fix the problem.
> > >=20
> > > I would really need Paul (or someone at Synopsys) to confirm this
> > > somehow. Maybe it has something to do with how the register is
> > > implemented, dunno.
> > >=20
> > > Paul, do you have any idea what could cause this ? Could the HW into
> > > some weird state if we read GSNPSID at random locations or when data =
is
> > > being transferred, or anything like that ?
> >=20
> > Only thing I can think of is that there is some silicon bug in Robert's
> > platform. But I am not aware of any STARs that mention accesses to the
> > GSNPSID register as being problematic.
> >=20
> > Funny thing is, this code has been basically the same since at least
> > November 2013. So I think some other recent change must have modified
> > the timing of the register accesses, or something like that. But that's
> > just handwaving, really.
>=20
> Alright, I'll apply this patch but for 3.20 with a stable tag as I have
> already sent my last pull request to Greg. Unless someone has a really
> big complaint about doing things as such.

But of course, I need a better changelog :-)

--=20
balbi

--bPWyEuR5EuEA2EVk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtvBjAAoJEIaOsuA1yqRE3goP/1MzoA6iV3cBF1jeN2bHmS07
FLoNtrHepPkETOdzG38Kpm8wdFeWWn5FLjC0yNvPPJQ1k4LOf1BId1qKwjA7oW7c
VWSvVEjLGmBHFhCcKzz+Hh2FNrLeEJ7RXTE/E+ETf9+6nmoPDF3ZmIEhMH1x8Uz9
g8Ykk7dbke8Z6oUBnq/lLzN3hASjdRAXCC8Fe4cGhv2bqTmkv1GTevsD8394QN9w
9FWoxNDYc8vvEw4VP21durwzuDZWbF+w9VN+6l/YRn/dUaGuONsoPC63QPn1uK8c
jVEVV3klbF3SDVKit1Juz/LXvOCF9j6AZMp2wt3g97D3BXjvFAZESxpft6Vs/ziA
RDcU6I9Ci6xVruDGcNhjv6D0cLFDCvb1F5Ts9vb6jyIIGWA7KcG6Rtit6CFhENDe
6SNK0ik77DK/kCi6wI+2MVO5gzDs+RY0PiEvECYWx2EK4F6jp5JfTNjhOcDgE+lh
LYyMT53VPZiet2bZ6Mqks9YCq1PHqTKfMWe3QRo5tmI78AJWtzq2nPScy1Jl22AD
iSxTd2pq88x/+CgTYJvTxVKz9Huw6HO3vim0GpwtZsonUFa+SE7dG6OJ3NzxFM+B
wht6kp0W9cgdbTPNlv5KRy92kOybJOjpa/LIw/iSPjIzaW3P6gYyE3S2GNW6nFY6
wSkLlD5IfhGK+Q65AmPv
=4KI1
-----END PGP SIGNATURE-----

--bPWyEuR5EuEA2EVk--
