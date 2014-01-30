Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaA3Dzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 22:55:43 -0500
Received: from ozlabs.org ([203.10.76.45]:59211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaA3Dzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 22:55:42 -0500
Date: Thu, 30 Jan 2014 14:55:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20140130145529.be54098a5eb5414f14d85c9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_14_55_29_+1100_4YiBNhvItXwmGaiw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_14_55_29_+1100_4YiBNhvItXwmGaiw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

arch/powerpc/kvm/44x.c: In function 'kvmppc_44x_exit':
arch/powerpc/kvm/44x.c:231:2: error: implicit declaration of function 'kvmp=
pc_booke_exit' [-Werror=3Dimplicit-function-declaration]

Caused by my conflict fixup in the init tree.  I just reverted the rest
of commit f9315b9d2680 ("powerpc: kvm e500/44x is not modular, so don't
use module_init") from the init tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__30_Jan_2014_14_55_29_+1100_4YiBNhvItXwmGaiw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6c07AAoJEMDTa8Ir7ZwVBekP/js3fE8Hq55CuRyU92Vkjurp
royK7OTd+Bt1hM+QVVsq2BXWPISbMc/i59CpWXez3VMZk1fXfscLeNS9YGZt3uTE
CveE9oG67P6dJ1Ym4m261mzcDAWgYF6ckX8mlzGdrge3n4RT+K/sjiaUZDzv2k3+
g+7e6kDWvkM+Anj6gw7SqXPzUBtGxcswTKC9DOK+2y1GKXH5TmbiponDMVoF3ki3
nd2ql56PAKlVTGtrLkblHyb28kwXlULx1QhmL8tfGcL1QD4cBAz2o3kHMVUafNER
n2Yz1LRpOD4rN2qt2vMCbqF31OHy59vYKIXkv4968IKixoBV2e2cCBlUMxDvLej/
QWZVrQGDXn4H06h7839CfAbVX2J/yHapDgabrhXPiTbseW86t7w3MoMB7Kkuspdm
uOeis/CHP2wOGpH8BwIDB0yjoQvVzGBHg9b/tPQBn+d17Fm8rR4OUdQ3yejou/6h
vEp11utGW9ax6wxxZlarisJl6PHngAQYSuLiFYMZI59JY/hyxTcrA7Pk5LT+xmll
AGQQmJ0PZo2cKxfyPH3rFmRjMi3pk6+bGfDCrXvP8D7i1xERP5oV9k/ElTRYDLuH
QJ5VEks9qPB3xEMUKKJQdhuUCxkgWFrAZcXbn76JLwJJltleMJ1DIp7hZb1LtCfX
KLhTqHqTEtD9W2lUcM9D
=jT1P
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_14_55_29_+1100_4YiBNhvItXwmGaiw--
