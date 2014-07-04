Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaGDPRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:17:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54737 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaGDPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:17:00 -0400
From: =?ISO-8859-1?Q?C=E9dric?= Villemain <cedric@2ndquadrant.com>
To: Christoph Hellwig <hch@infradead.org>
Reply-To: cedric@2ndquadrant.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: introduce fincore()
Date: Fri, 04 Jul 2014 17:15:59 +0200
Message-ID: <5816450.BPnLjGgtl5@obelix>
Organization: 2ndQuadrant France
User-Agent: KMail/4.12.4 (Linux/3.10-2-rt-amd64; KDE/4.13.1; x86_64; ; )
In-Reply-To: <20140704101230.GA24688@infradead.org>
References: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20140704101230.GA24688@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8084549.9xpDVVycgD"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:NEBePmFMGarOcGPMjsyjIpIe6HomFTSA460V0bK5c0+
 XD9vdP82fFcEtqUVu/Led1Olg25MadCsnW0V0OCQpgtnktkNKl
 8ys9OB53uQ/FaGh4x7rwI0yz81GBeeYPJsJOvFVQS6gS4ls5Bo
 XHyMsXLBEcgwycgGMUfjzroLUtXSCMJjHminjWt3sizkBKh5TA
 8XaEYK3KjU28ORzv66sQj1kOs1+MhjVIguDnzcLD2tQbyc4cpm
 362QemVLrfw0w0wAiYnVXpGuMT18uuKwZJjOVRy+ovZJ4DF1bi
 jrnLeWdEIM3ub6Wd+M4eth7G+tqrUfRsu9EHwIa4bkoIoPbp6L
 wuGOOjDEM3tZUqVoOXb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart8084549.9xpDVVycgD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Le vendredi 4 juillet 2014 03:12:30 Christoph Hellwig a =E9crit :
> On Thu, Jul 03, 2014 at 05:52:13PM -0400, Naoya Horiguchi wrote:
> > This patch provides a new system call fincore(2), which provides
> > mincore()- like information, i.e. page residency of a given file.
> > But unlike mincore(), fincore() has a mode flag which allows us to
> > extract detailed information about page cache like pfn and page
> > flag. This kind of information is very helpful, for example when
> > applications want to know the file cache status to control the IO
> > on their own way.
>=20
> It's still a nasty multiplexer for multiple different reporting
> formats in a single system call.  How about your really just do a
> fincore that mirrors mincore instead of piggybacking exports of
> various internal flags (tags and page flags onto it.

The fincore =E0 la mincore got some arguments against it too. It seems =
this=20
implementations try (I've not tested nor have a close look yet) to=20
answer both concerns : have details and also possible to have=20
aggregation function not too expansive.

=2D-=20
C=E9dric Villemain +33 (0)6 20 30 22 52
http://2ndQuadrant.fr/
PostgreSQL: Support 24x7 - D=E9veloppement, Expertise et Formation
--nextPart8084549.9xpDVVycgD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJTtsUyAAoJENsgH0yzVBebWBoIAJhFEeV28nzkW/C4Wi3s8YXZ
CgfL6Kpu1jvhMQC/5ni4RquqQoZtRtHU1/qBuW5e1njazdflWhTRxsf3zff3mOMD
owZbKbi8s8UT9m/uEB9Yv9vXFmiWhpXL+yqcniQWW5WUNCIP/X3F/fMVzlaydrCb
vUQlXvJ1p0sUrtualRry3sQpPk/OxT0Fa1n3HdiC4X9wfv0EX8OSXjekZqtUS0NC
OUsXEfnaB/KmbiqRLGBgxoofynMby2089Cgi13+MHFvS32YzRA+x0/dbKUJmpN2I
j0FCbJEc982/BIK2vpSPZk+/0ZZkWjYDx5RNHGuwYc1FimvN4UdgR4AHnp9DWo8=
=AC/X
-----END PGP SIGNATURE-----

--nextPart8084549.9xpDVVycgD--

