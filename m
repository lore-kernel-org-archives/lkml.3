Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3DZLld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:41:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3DZLlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:41:32 -0400
Message-ID: <1366976479.5955.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/26] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Apr 2013 12:41:19 +0100
In-Reply-To: <1366976326-nb0h8oyn-mutt-n-horiguchi@ah.jp.nec.com>
References: <20130423215333.344045754@linuxfoundation.org>
	 <20130423215333.802657218@linuxfoundation.org>
	 <20130424230410.GB2619@decadent.org.uk> <20130424232329.GA9073@kroah.com>
	 <1366976326-nb0h8oyn-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vjTA39eUSRGRsULOFYBX"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f95e:74f6:4873:febb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vjTA39eUSRGRsULOFYBX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-04-26 at 07:38 -0400, Naoya Horiguchi wrote:
> On Wed, Apr 24, 2013 at 04:23:29PM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Apr 25, 2013 at 12:04:10AM +0100, Ben Hutchings wrote:
> > > On Tue, Apr 23, 2013 at 02:53:44PM -0700, Greg Kroah-Hartman wrote:
> > > > 3.4-stable review patch.  If anyone has any objections, please let =
me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > >=20
> > > > commit 9cc3a5bd40067b9a0fbd49199d0780463fc2140f upstream.
> > > >=20
> > > > With applying the previous patch "hugetlbfs: stop setting VM_DONTDU=
MP in
> > > > initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a m=
emory
> > > > error happens on a hugepage and the affected processes try to acces=
s the
> > > > error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <=3D 0)=
 in
> > > > get_page().
> > > =20
> > > Is this required?  You didn't apply the previous patch referred to
> > > above (commit a2fce9143057) to 3.4.y or 3.0.y since it claimed to fix
> > > a regression in 3.7 (commit 314e51b9851b 'mm: kill vma flag VM_RESERV=
ED
> > > and mm->reserved_vm counter').
> > >=20
> > > I'm not saying it *isn't* required, mind.
> >=20
> > Yeah, but I went off of the stable: marking in this patch, which said:
> > 	    Cc: <stable@vger.kernel.org>        [2.6.34+?]
> >=20
> >=20
> > Naoya, any chance you could clear this up?  Is this needed for kernels
> > older than 3.7?
>=20
> Hi Greg,
>=20
> Kernels older than 3.7 need this patch.
>=20
> We need this patch whenever hugepage coredump is enabled.
> It was enabled before commit 314e51b9851b (=3D=3D v3.6-8946-g314e51b),
> but the commit disabled it accidentally, so commit a2fce914305
> (=3D=3D v3.9-rc7-56-ga2fce91) reenabled it.

Thanks.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-vjTA39eUSRGRsULOFYBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXpn3+e/yOyVhhEJAQrfsg/+Ov6+1k5Uy08GPSg3KmXHDEiWVVMxkO5T
9wwptpce4Av3sqyG+xIgDXKcAB5WIzhEPGuAadI4ZH6UyiVuzac8jc2DUF9u4uEH
LmMDlsyTYSeDitofbyRw6ttO7F9THdjlSHSm1cS7m7pu3XAPelAlb+t9hXcygvlu
S5crLEl5GNHjE5WKcGCRV+Ix12vLFwZyOCCbeOQIFXEZ2GXc0GY6sSOOv6q0rzT6
5KEX/qFptDepwh9SfLfU9SQdpQg4OIl5DsnR1dorH+maA6k9T2gD+3QiMa4EAFT9
UZmBWAs0Fol3Qisp60e9CIWTAhPEBMcMzm6nTZ0FX+lxDwrtAt9Q8WMwglCc8JCA
EZSBqtjbAVfAlbckjnzToRQw58xBLjy0pvEo8bP834xJJQgWngF6fBnDcfI9Hqpl
51P60v7SPLbAY67MENTEwJ5jBPjQX2Q999kIjBKEJELwW4TB++nLSnNUsxZqR/yg
vMVkuN8+6DWuftR4vvhco0gJ/EIuvqLiiu/ERJ8HmyRhevqQHD2WVWTWDB9lFMjH
O8lPwRhHJ/SBi0W9qL2SGy8zhLV+9DbGVaI5ekEQui7XnihSVChxXAz6Jnwr9t5R
isPG6igwBH7jC2pdxdQtYmp41kQsszSlonxn9CZ8HC1t7v/scoMVcxCs/ul2V1nX
EGbtgY/Cyhg=
=kBPD
-----END PGP SIGNATURE-----

--=-vjTA39eUSRGRsULOFYBX--
