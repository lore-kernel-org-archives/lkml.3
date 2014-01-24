Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaAXEES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:04:18 -0500
Received: from ozlabs.org ([203.10.76.45]:52901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaAXEER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:04:17 -0500
Date: Fri, 24 Jan 2014 15:04:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-Id: <20140124150401.c0cc951a93341b569b21f749@canb.auug.org.au>
In-Reply-To: <20140124035312.GA31095@kroah.com>
References: <20140124130122.017195b49e852e4e42b77997@canb.auug.org.au>
	<20140124035312.GA31095@kroah.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Jan_2014_15_04_01_+1100_p4fWzHGcEMGqr6eF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jan_2014_15_04_01_+1100_p4fWzHGcEMGqr6eF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 23 Jan 2014 19:53:12 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jan 24, 2014 at 01:01:22PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the staging tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_beaconing=
_flags':
> > drivers/staging/rtl8821ae/regd.c:200:20: error: 'IEEE80211_CHAN_NO_IBSS=
' undeclared (first use in this function)
> >       ch->flags &=3D ~IEEE80211_CHAN_NO_IBSS;
>=20
> Wait, I can't duplicate this at all here, either on just my staging-next
> branch, or when merged together with Linus's tree.
>=20
> Can you send me your .config that you used to cause this to fail
> (allmodconfig works just fine here.)
>=20
> Could this all be due to some wireless patches that aren't merged with
> Linus yet but are in linux-next?

Yep, commit 8fe02e167efa ("cfg80211: consolidate passive-scan and no-ibss
flags") from the net-next tree.

> If this is going to be a pain, I can easily drop it all and just wait
> for 3.15-rc1, but it being a stand-alone driver, that works for hardware
> I have here (and rumor has it, Linus also has this box), I figured I
> would try to stay ahead of the curve and get it merged :)

That would require that I fix up the semantic merge conflicts on
Tuesday (I have a long weekend).  Unless you wait just until Dave merges
his tree and then base on top of that (or do a back merge of Linus' tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Jan_2014_15_04_01_+1100_p4fWzHGcEMGqr6eF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS4eY2AAoJEMDTa8Ir7ZwVJFEP/0JmYSD6Ot7oAlcwNmBNTpIb
hvKQ/Aaaxu3BgQelGdrLnt5uatQ/PA3W6eqRCLyqbqKzha5m26JdTipt4tf8FsKy
TNAs8oh9Odhpqb8j6bb7TsgCQM5qGV/2OfTYiw4XP+uQYS/zZuAxU57hhQeuFsbn
6OvxBbLX5G0izxr+VlKobCMvHzhCI1q4xjQ+6P02jJNuuU+NmRHmZhw16SFDY6xI
s+ZPs56g2bOCN0KFkOHskGZtYD4U8ZlABzB9+2DHiYBFPUNrlfhlmBZTPSRb7ci3
fTQTFP4NCaF1BjKg2CCfGZEXTDCvG6gZSoTgy8kFnQWIq8bmQDh5ewjyKNRBrcv9
3cPdkAjxbFO5+VmzdSKOzA7WLSbzVeD6H78HtIO56IEvJYK73AAUnJk/emgWK18Y
IJiH/bzTSmM98jGZi/uKsEwRKPlc7uJAhN9xbFeNPw12+IqC4WQimp9QQJkF65x0
EpIcIO9XaypqFYHYndZb9Zwe8xV4w7s9Ulh1Jwhuaenp/h6HFVKmhuCU1Y4r2Y7E
ufbzZe1bSxbJez+Y6qmsyKd1wDfyqEddaHm/Fi+LyPelc4dx4e9BLYbrfFqwpCoh
lX58wLJ3jh3/cPI9GBBnIn71FjSYVJcIWRINCvUlOLxrp+Kn5jzMo1wqT5Oa/Msv
5rxj62HbtfYh/WHhOZrc
=xvGp
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jan_2014_15_04_01_+1100_p4fWzHGcEMGqr6eF--
