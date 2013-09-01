Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3IAXxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 19:53:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49529 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3IAXxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:53:50 -0400
Date: Mon, 2 Sep 2013 09:53:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130902095348.b8687db80751d2cce4cad8bc@canb.auug.org.au>
In-Reply-To: <CA+55aFwWEqzGi7uW_xPt=eC0FC-5qnom=W4x87xbH_a2Oy4=6A@mail.gmail.com>
References: <20130830181202.bea6400ec4d92744e05b5b9f@canb.auug.org.au>
	<CA+55aFwWEqzGi7uW_xPt=eC0FC-5qnom=W4x87xbH_a2Oy4=6A@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Sep_2013_09_53_48_+1000__A69wq1F6x/5+1xL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Sep_2013_09_53_48_+1000__A69wq1F6x/5+1xL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, 30 Aug 2013 08:25:06 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Fri, Aug 30, 2013 at 1:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > I don't know if it is safe to read d_lockref.count without locking
>=20
> That's not the issue. Since commit 84d08fa888e7 ("helper for reading
> ->d_count") non-core VFS code shouldn't try to access d_count directly
> at all. So instead of "dentry->d_count" it should use
> "d_count(dentry)". Then the code doesn't need to know about lockrefs
> or anything like that at all.

Thanks for that.  I will implement that temporary fix in linux-next today
unless Andrew has been busy over the weekend.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Sep_2013_09_53_48_+1000__A69wq1F6x/5+1xL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSI9OMAAoJEECxmPOUX5FEbngP/2Tzu5CM0fFVY2el3x9ubNXu
eW/C95ybFmDk1wS4AX4OFdOa8bgsRxk9hNgWTrODG5l8vEVbtfc4Yjpp/t5NkKJW
iGnD8e/TK7urwZqyGF4rU9vf7d2cSOnWTLwy+smr4D/LDS1atdLDUbXNa68Uj5rE
fk1BFskiEnHq0p5FCpfLV0A0yzW8mleVp4R/2e3zlhZEOrs8Guto+ipCJkrkQu/Y
7Y5as6AEliElIxUO8HHArgTIJ8p6HA3Os5Z164NtTcRtFj7o7yeb9sdZ8I5sRlNL
h7N9VdxpZ3p5I69mzhjrDo0zulZtu6hMQOugNYYaeQ2dNrkDvY/wtqgS7FQZvuGZ
uiYMAQ2R5f0GdXnUyaVZjHcylE/cU1MWe2ppEIADE1w0yN1LPG50bkAsQfJKaB2o
vPr/vOLLfPoPUrtakOZtny1u8Re0l9bOJZYXosT9ZyjyVgA8nuaA/sHmPdueMEWH
+Ch8RnyGVlJhd/wA7vMCh+9P6ofzMNOtPbalfXGy3xutNSvZIZkI8HR+6DYqeCqg
fn14ad9SCPTc1lt4P62L4BA8o2VdJUxhopr1rLTrcN1rphujZbTeN8ku4aDreeOq
nnVtW/Ej9Se/sVYXhZGBeagKyTUpX94EIOnWBQ14jnPF3oQJrDOGMSmIDoYr1iy9
iZLXs5W2eBiZNn2YgQRq
=tCUU
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Sep_2013_09_53_48_+1000__A69wq1F6x/5+1xL--
