Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBYUrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:47:51 -0500
Received: from ozlabs.org ([203.10.76.45]:59440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaBYUru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:47:50 -0500
Date: Wed, 26 Feb 2014 07:47:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140226074738.0b530aebe4cde54216698d91@canb.auug.org.au>
In-Reply-To: <20140225190715.GA4384@tuxdriver.com>
References: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
	<20140225190715.GA4384@tuxdriver.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_07_47_38_+1100_Rr0BhqvI_E=iCotQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_07_47_38_+1100_Rr0BhqvI_E=iCotQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Tue, 25 Feb 2014 14:07:16 -0500 "John W. Linville" <linville@tuxdriver.c=
om> wrote:
>
> On Tue, Feb 25, 2014 at 01:35:37PM +1100, Stephen Rothwell wrote:
> > Hi John,
> >=20
> > After merging the wireless-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' spe=
cified in initializer
> >   .module =3D NULL,
> >   ^
> >=20
> > Caused by commit 161d78555435 ("Revert "Staging: rtl8812ae: remove
> > modules field of rate_control_ops"").
> >=20
> > The commit "Staging: rtl8812ae: remove modules field of rate_control_op=
s"
> > was needed in the wireless-next tree - I said so at the time of reporti=
ng
> > the original breakage:=20
> >=20
> > > Actually, your tree is based on -rc2, so you need this patch already =
(it
> > > should have bee included in the merge commit 841577c3d33b ("Merge bra=
nch
> > > 'for-john' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next").
> >=20
> > And now that part of the wireless-next tree has migrated to the net-nex=
t tree.
> >=20
> > I have no idea why you thought you should revert the fix.
> >=20
> > I have used the wireless tree from next-20140224 for today.
>=20
> The fix should go through Greg's tree.  I shouldn't have merged it at all.

No, the fix was only required in your tree (since it was a patch in your
tree that caused the breakage).  And that fix is now in Dave's tree, so
reverting it in your tree just rebreaks stuff in your tree (and in Dave's
tree if your tree is merged by Dave again).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_07_47_38_+1100_Rr0BhqvI_E=iCotQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDQFzAAoJEMDTa8Ir7ZwVDHEP/2EDEi9crIuM6195Rzhru/uq
XsHnhEwBT4ET7oa9O4PwthxyzSnTbyFks+7zdVsDBY371derS1xTtaHQic4TAjNZ
BhWFbhAYX4uq7InYhsxY97wvELiXxbtLuW3lX8NNxYZQq24ny0msOuBqBAIdwo7q
Cwyj2XEUxzC3bLejFpdVaF/WRC56ayoHjmFBgUmRAsAY50tlzS0U7L2i20yemjVA
AfpIN5TWsNAooPm5tb+ZuJA7qzbrs6eZCHgA5RFfgk5F558D/T7se7CokC2x3csu
irhSM6Om07jD8PCfnLS9LaApwWO8UkgT6YvYejsf7azSTZ3l6G/5Qb7E9fMGtLO1
HOi4BWzctsfGJB+YUs4idBdkz4v+BoIv1vmNzO9mJU15WAdiLePv2eEZJvQY86Lu
hqHqNmFcSijVcHtvOgSBCJzvYO36pUI4EQjDNW3+gBcFAcEyptGllwHr81f/sKMU
84/KE3nda9lXEG3/cPhGYSGhv7HIwjX6rWPGnDt7tUYUfXqq8ykixq4NGq9UTUy1
XpzPl2+g94rwyW2od0Pup2wrxwB0V9f87m5xvO1xIRbBtVbqp9edmz4R95t5YtWG
pAk8jZfRWCucAJCsXtouOYAUmK9ag1KoiFMq3RvQLfCOhBNlRoer8hb/JEzqlBwE
Vq7j1k5rkdWcTl2O8q+i
=P/mD
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_07_47_38_+1100_Rr0BhqvI_E=iCotQ--
