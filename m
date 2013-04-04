Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765210Ab3DDXTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:19:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55435 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765142Ab3DDXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:19:04 -0400
Date: Fri, 5 Apr 2013 10:18:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130405101853.769d3b915cacd8a4863b7c19@canb.auug.org.au>
In-Reply-To: <20130404081011.GO21522@ZenIV.linux.org.uk>
References: <20130404172648.27834d12cbb68338f4b89482@canb.auug.org.au>
	<20130403235634.6bc72c39.akpm@linux-foundation.org>
	<20130404000253.2fc9c75d.akpm@linux-foundation.org>
	<20130404081011.GO21522@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_10_18_53_+1100_q0CGuO8FIiErykVS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_10_18_53_+1100_q0CGuO8FIiErykVS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Thu, 4 Apr 2013 09:10:11 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Thu, Apr 04, 2013 at 12:02:53AM -0700, Andrew Morton wrote:
>=20
> > > Well perhaps the vfs tree should start paying some attention to the
> > > rest of the world, particularly after -rc5.
> >=20
> > I can't even find this "lift sb_start_write() out of ->write()".  Not o=
n fsdevel,
> > not on lkml.  What the heck is it and why was it so important?
>=20
> Deadlocks around splice; see the threads re overlayfs/unionmount/aufs and
> deadlocks in their copyup implementations.  See also XFS freeze-related
> deadlocks, etc.
>=20
> The thing is, sb_start_write() is pretty high in locking hierarchy (outsi=
de
> ->i_mutex, etc.), but ->splice_write() and friends had it buried pretty
> deep.  With distinctly unpleasant results, including ->..._write() instan=
ces
> using generic ones (which took the lock) *and* doing some IO outside of t=
hose
> (ext4, for example; ocfs2 also looked fishy in that respect, IIRC).
>=20
> The obvious solution is to lift taking that lock out of the methods, which
> had been done.  It had been discussed on fsdevel and sat in #experimental=
 for
> several weeks; time for it to go into #for-next.

It would have been useful to put something like that in the commit message =
...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Apr_2013_10_18_53_+1100_q0CGuO8FIiErykVS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXgpdAAoJEECxmPOUX5FEfVkP/RUeL6JuiTZSoUXc02z0PcdN
hS26kfzYp6Ziz0MUHx/rauzVqNm6+swCQqnwc8v4smzc9acBIMhIvpSl3UuAw4HO
T673B7MYqLyJ0WwsX21ChZ9wETGY2BIXCE+mzVtAv+7LPRVX0ZRFBBgyCnsBgn6n
v7oIIBH76eM2ZDY4f+aUNaxlVVdLlfLy3liG+vpal3pRa5WLfXxvyL3Ax0iYGRJk
V3Td7/j175gWyOs93srej7ryNYVpk1e0BRB7wnXHEZu2HEAmW8IsDrUZYVJEQR6D
71p06t+Vl7KzG8+R6DjKMnRIOT/iLjv5OkrKkYopLoX0wzmRwcj5vwvNAcdOJAmc
DdVcgsqmKIKIfV4gUhImBLhF/S+NnQv3m3DegRC1j4MpeKczZIRaeuhT73H1RjzA
TcevApShCmp3YHEHSvjilBbPBPwjEnu4I2V4M5TzX/EmtTnJtEc5Unu0lJ5eu/+N
5LXUxWoU6EUg0+kCrfCNq3cFXLGy7jAXaoiB2z4zVA7LswvHTbqF5Vm8DNjJwuQ+
qF0dhdsORObCrFL7SBBxqRFp/CM0UhPv7I7rmcqReHxbFwSbuZ5fDZKWzvbzxRKM
WKoXNxmnGh8LejrPrdExnm77dS61W9uWbv8Q9XZ9x8Z8PQoch5QihZBB1Dzva6nA
YLWeGP/utc+7lrv+dZXV
=Yn9n
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_10_18_53_+1100_q0CGuO8FIiErykVS--
