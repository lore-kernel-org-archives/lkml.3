Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaLJIKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:10:00 -0500
Received: from ozlabs.org ([103.22.144.67]:53323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaLJIJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:09:58 -0500
Date: Wed, 10 Dec 2014 19:09:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: linux-next: build failure after merge of the rcu tree
Message-ID: <20141210190945.3af6868b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AS0MT6.JvxLt+U+D2jM7NrP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AS0MT6.JvxLt+U+D2jM7NrP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc64
allnoconfig) failed like this:

In file included from arch/powerpc/include/asm/kvm_ppc.h:30:0,
                 from arch/powerpc/kernel/setup_64.c:68:
include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
  struct srcu_struct srcu;
                     ^
include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
  struct srcu_struct irq_srcu;
                     ^

Presumably caused by commit 6e8ef258b669 ("srcu: Isolate srcu sections
using CONFIG_SRCU").

I have reverted that commit again for today - more work required ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/AS0MT6.JvxLt+U+D2jM7NrP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh//RAAoJEMDTa8Ir7ZwVixEP/3PHERwBSlA7u0eQSqRDgLwQ
UYUKMRU877RPEp+QO9uXRgkdoaN34tPF6DocES2Mi2KZdPC52YoXuexEJcBeKE7l
V7y9g720xV7mwNc+Lc5Ev3ZECiYi63ZUBFMgdfTRPPrHo8U8Z9FCTZAewEWn+/fu
X99tS38jPQbbJ5RIoUHW86OO+gRMf0XDu2HWTbq7mCJmF+ZABJWhHBR+bPj0Oqhf
ByVOjoKb5+QN6fLHVDqt9yMOrCyoVG79S76CPN38mgHDjhcYx9ERZU4tjFGC74dR
AkfmZxSWGNzjQ1noowRN45uP58r3x1jq6hAJqcOhbhP1W8+7nfUcrviaFQXdkVQ8
PgVfqpwAOEY8J82df9Zu06KgHWqifUmFCMTTqVczWR7DKLQvoP2FJ58Ylh9eKq7O
aI1QSacRLFA8xlwetgdIUMMBo1QY2uqODpN6aMZalF76kdfWseuPBEfi136uFf+e
vthBRrOeEWtV1G9oWSBDvLgyvWi3ZFBqtUp5tJ7+MHhYFkCqd2Ov37aByZpsGVwp
dUbxBbJhfDDHw7I6ILQ8wIYefIn5ZPp0fxqu4mEFLcOdu4R0Wikcd/42XnIlGl5j
j9SPCy3dGYBVIvqOyUJhRMePFTSXb/ZS4hrI14TXlpr5CAnzqYLwzUi5/SGY6SVP
IJc3LUEAMnMFrM/VV6Cy
=Iszr
-----END PGP SIGNATURE-----

--Sig_/AS0MT6.JvxLt+U+D2jM7NrP--
