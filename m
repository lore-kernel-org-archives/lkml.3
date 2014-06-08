Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaFHCDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 22:03:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39228 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022AbaFHCD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 22:03:29 -0400
Message-ID: <1402192995.23860.21.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.14 103/228] revert "mm: vmscan: do not swap anon pages
 just because free+file is low"
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 08 Jun 2014 03:03:15 +0100
In-Reply-To: <20140604232351.347803140@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
	 <20140604232351.347803140@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-86vtlVd08ikt+OzqOkcv"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-86vtlVd08ikt+OzqOkcv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-06-04 at 16:22 -0700, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Johannes Weiner <hannes@cmpxchg.org>
>=20
> commit 623762517e2370be3b3f95f4fe08d6c063a49b06 upstream.
>=20
> This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
> just because free+file is low") because it introduced a regression in
> mostly-anonymous workloads, where reclaim would become ineffective and
> trap every allocating task in direct reclaim.
[...]

That commit was not included in 3.14 or in subsequent stable updates, so
this 'revert' is not approriate.  We now have duplicate checks:

	/*
	 * If it's foreseeable that reclaiming the file cache won't be
	 * enough to get the zone back into a desirable shape, we have
	 * to swap.  Better start now and leave the - probably heavily
	 * thrashing - remaining file pages alone.
	 */
	if (global_reclaim(sc)) {
		free =3D zone_page_state(zone, NR_FREE_PAGES);
		if (unlikely(file + free <=3D high_wmark_pages(zone))) {
			scan_balance =3D SCAN_ANON;
			goto out;
		}
	}

	/*
	 * Prevent the reclaimer from falling into the cache trap: as
	 * cache pages start out inactive, every cache fault will tip
	 * the scan balance towards the file LRU.  And as the file LRU
	 * shrinks, so does the window for rotation from references.
	 * This means we have a runaway feedback loop where a tiny
	 * thrashing file LRU becomes infinitely more attractive than
	 * anon pages.  Try to detect this based on file LRU size.
	 */
	if (global_reclaim(sc)) {
		unsigned long free =3D zone_page_state(zone, NR_FREE_PAGES);

		if (unlikely(file + free <=3D high_wmark_pages(zone))) {
			scan_balance =3D SCAN_ANON;
			goto out;
		}
	}

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-86vtlVd08ikt+OzqOkcv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5PEaOe/yOyVhhEJAQoDsBAAqPJO3qCkvtXOd9G0PK6t0cLc0FwDyewh
McXlLAwZJPmB3XnGUz1m0JRlwV7/mMTHSvzjImLpmsNtm/4O5ohTW+yBEG2URXeY
H4HXYXfjuytNypEIBraWb9YUN6C2IfDI7CVMaikXvaNMFTy3nQ0NeFT9uKr8yXv4
6oPXkGU8jD0TjX0Geo1BXxdlNBXX3SNFQClkppp2P+cNhVD/GI9lxzm+HBOW/yTN
PlGhjmXUHFN/ut/2EUQ38BGQlxq42dKCWNojfz5OyqcFCTrFwvuCb6dK3iCYtPs0
cpz2iu4bL45CPBU44d1jf1sz0PCzAqVFRpqSrHckZa0ZohGCBtS5Vyj6EyeLtKs4
UKjrSUrZHmYdNKfGi0V+upgZGVmh2Y0pAbe2T5T9IaStor1WBIuvJqTMY0ONmNE+
exBmnhEdrojSavlQoJkpj94p4zStZCi1eYhAs3dWVcDjS2f+WM005lR+7SMPz2wP
icmWsOWP2e3FOwVfxAZeS+qx9qlt8LMhUvKWP1SiM//ZF95ZKOfEY4/bjp+V0DWO
JCClSPm9RXQcIoelafQ/CSGopRpIS61URUKY9zdPT4SzoqLJ1rMATW72u/b0W7yH
yp+li6h6oXS1EPyVbkwwU3VB8yn7rj2tF8oo6WAKV6guhYi0Wgf6ZGcSYY2hc7To
81o4Vuo/zZE=
=1KuR
-----END PGP SIGNATURE-----

--=-86vtlVd08ikt+OzqOkcv--
