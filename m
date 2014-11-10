Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKJHRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:17:24 -0500
Received: from ozlabs.org ([103.22.144.67]:43638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaKJHRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:17:23 -0500
Date: Mon, 10 Nov 2014 18:17:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: linux-next: build failure after merge of the tiny tree
Message-ID: <20141110181716.3c9604fe@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/trrt3ELlGlJWTm3CfQiR7NM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/trrt3ELlGlJWTm3CfQiR7NM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

After merging the tiny tree, today's linux-next build (powerpc64 allnoconfi=
g)
failed like this:

arch/powerpc/kernel/built-in.o: In function `sys_call_table':
(.rodata+0xd58): undefined reference to `.compat_sys_adjtimex'
arch/powerpc/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x1b48): undefined reference to `.compat_sys_clock_adjtime'

Caused by commit be1e48a8e48f ("kernel: time: Compile out NTP support").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/trrt3ELlGlJWTm3CfQiR7NM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYGaAAAoJEMDTa8Ir7ZwVU5sP/1B9cqDny5jAziaRuD+B+r0L
Kt9DLjAmX3QO4DB53QQB/5wx7igFTfs1wuESo7v9sGIc9kpLuaGarFxbZ37IyRX3
QYmNLiXleGnK+TqGWJ92Vskbgb/dsnAOaMr46EwGdyc/YfUVdgdZBQH91QWUHzWt
kvrYSw/wF1HkzSSEN12TY9k1Q1NMZAwo74Bgt2Bnx9b+mwHP2sbrdTQP8X1dMTan
oIDa4X5Tdd07nQuiSU53XU7NN+V8ZfD8OMex2SLtjigdxUpulTi8yA5hbpVFarvO
VqH5NFhs9/Qn5P5O11PtB2i8YGGT1lYmPxfzZ1tF2ah/gvIvezFVFLZRJmKnD3Mg
LvOlo8g47FW6b2otgElnuShnL6SkRLvETOG/pMNPb61tbM1uL5rzqUerB6/exVtM
PH1zsOC/j2Ns/gAb1bKK1hJ87Mj0o1H1TALi+iteudaqsiQlo5i7wmi6fIDZ69ms
n/Nx4I1txnGaDM9tSVlv2phaumoKlg2s/exVzremFMAamxvG3Dhcx8mpAJOn4JxF
9djOt0EqFuxchIDZ3Dhg+dWBQkh14hYFX11zbzfjEPgYAPIfq7tyDitCx6u2SJj/
swak3XQOUE6RziitBoO0zOBJ+MDz7CJ3F8ePwbn9pjpM5wz3FwOwyXaQPRLPdUOL
Rsh1EisuWFxuN0MM8QMz
=ChfC
-----END PGP SIGNATURE-----

--Sig_/trrt3ELlGlJWTm3CfQiR7NM--
