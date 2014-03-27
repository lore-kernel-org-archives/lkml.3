Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaC0CMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:12:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57199 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaC0CMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:12:42 -0400
Date: Wed, 26 Mar 2014 21:10:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Message-ID: <20140327021043.GB11651@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-10-git-send-email-balbi@ti.com>
 <20140325182856.GA31906@atomide.com>
 <5333732F.6040803@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <5333732F.6040803@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 08:39:11PM -0400, Peter Hurley wrote:
> On 03/25/2014 02:28 PM, Tony Lindgren wrote:
> >* Felipe Balbi <balbi@ti.com> [140320 12:39]:
> >>This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.
> >>
> >>That commit tried to fix a deadlock problem when using
> >>hci_ldisc, but it turns out the bug was in hci_ldsic
> >>all along where it was calling ->write() from within
> >>->write_wakeup() callback.
> >>
> >>The problem is that ->write_wakeup() was called with
> >>port lock held and ->write() tried to grab the same
> >>port lock.
> >
> >Should this and the next patch be earlier in the series
> >as a fix for the v3.15-rc cycle? Should they be cc: stable
> >as well?
>=20
> Well, right now the other fix has had _zero_ testing
> so not really a -stable candidate just yet.

how can you even say that ? Unless you work for some 3 letter acronym
organizations, you have no clue about the fact that this was tested on a
keystone 2 platform. How else would we have found the issue to start
with ?

--=20
balbi

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTM4ijAAoJEIaOsuA1yqREul4QAKHq2HAm+dn7ySPmkYJaCYEt
VoZ1MH1tZvn5hXqeAdYRKkJcyCWY6qbHAVPGpwQbLl+06I3e+NZFbx9QFcDbLA0s
ON5Sh7xaye6+AQeFoy43G94dg0VE87xbJuE/w5t93uDkSEWW79zSeZ3VsjkzZiBO
E3n4h84nLP+Ksl8+PRueEErPs7+GV7zqj6a/NBBvJ/Wxda3/8kyHdO6IKpdfgXlU
Pg34Iggenm/4y5ZDDW+HRKAhrJh+n96R9JDiYvu9Bq84vYYT+Ft/vG5uv1OWAEXs
Ap77qKyPuOq+NjCd/MkOvYH3jO+9RXQXJzNme0XpaqdZj0vZcUw/KQcEARvmLPPN
viT6v2IWR4FAT44zDhHbYjj0C4K0HtBKVzmrUsRCCPvsTxyWqKhJt3NDljG8xRst
pWju7FAVhBUDHl4xLKM2iZmRMQDEQCj/uldVQ544DwRWtd58vik+xntRM8SekYSs
vXUb+LWDwWlzHL38RxnCnxSF7d+yfF+mQsTfBIrCXvIfILDUpiYRwr9K3KPXappD
z4pJaJY5DYabg5SxvYVgSxNylWVl5ZqyeuATAd9YZml42odv1yPjiArO5QtOuUS/
AGrh5OImRICYPwD/VE+EtaikqVMlPSDdvyKALl+apx9cfU8H/pushQuBeSEaZKqQ
Riw7R1n70klzISorplNq
=YHH1
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
