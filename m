Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3BBCEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 21:04:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57373 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab3BBCEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 21:04:12 -0500
Date: Sat, 2 Feb 2013 13:04:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: linux-next: build failure after merge of the nfsd tree
Message-Id: <20130202130403.a29346b583a802ed6ce6880b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_13_04_03_+1100_u.JT3Mq/XF5yQ=Zj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_13_04_03_+1100_u.JT3Mq/XF5yQ=Zj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

After merging the nfsd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/nfs/dns_resolve.c: In function 'nfs_dns_resolver_cache_init':
fs/nfs/dns_resolve.c:375:4: error: 'struct cache_detail' has no member name=
d 'cache_upcall'
fs/nfs/dns_resolve.c:375:35: warning: left-hand operand of comma expression=
 has no effect [-Wunused-value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]
fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-=
value]

Caused by commit aab982cb5dfb ("SUNRPC: remove cache_detail->cache_upcall
callback").  Also, why don't those statements end in semicolons?

I have used the nsfd tree from next-20130128 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_13_04_03_+1100_u.JT3Mq/XF5yQ=Zj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDHQTAAoJEECxmPOUX5FEH/0P/AmAF4HaZ0zcckho12GTw6yO
IIRHUo0PPB29jBGrchEkMacuf/7PMjz390D8ApmDJ8tU0QcqY2yTtpcmhnQyV9I3
ydixxkdJv/OMLDwPC7Sb/bEDLhL9Y0k+RT1SmlKBMP3TXMkKLm4QzkaT9VXH4Ri/
BIdKxaoZFIXW+NQo9q+eH3LwEQJ05ZL0px830s9Z+PFe281kKESjN1t2ixrxMtkX
AD0cfxDMEo2w5oJl5b1iovHwGxajhx9Df7M0FzwLG1kPyfzTA7MsT9lSVAU6ceRE
mmzBr5gFi3k6IX+xMcddbQ9XIdIPCzI4fk4bLDKaEFUE9wQruWrKRC8CbWuCG1Uy
zFnK4srMVlD1XIy3cQS+PgWAjDRcvG1JDMxufrMJ4oBHwl0tyPjyX9c+1I1E9M9M
d0Rdvvzyb1kVT+rABrNHlkQcd1LBq51w77svYwSrdaLfQYjX7gy9T2z0xFIOFezA
Ttd01lILlTJepJkdTgD5/RGOBsr9DXbD2wXBElPZmXzJa+676T3TBbB7i8NRqg02
NQttzo1WbuWuV1ACQTRI98hqNteVWYKoiXdnRBG4KVLeJsI/94IJYCafQ02FAJKZ
/zLKGFuoDOfSlgotZsyitw61PIzWj0l2+pM4wZ+f7ZWbdO8rky/T9ZARAXumTHou
99eZmNVjLzUcabuAa7So
=1laO
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_13_04_03_+1100_u.JT3Mq/XF5yQ=Zj--
