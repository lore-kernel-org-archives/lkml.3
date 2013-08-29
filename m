Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3H2Jrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:47:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48303 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3H2Jrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:47:51 -0400
Date: Thu, 29 Aug 2013 19:47:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>
Subject: linux-next: build warnings after merge of the akpm-current tree
Message-Id: <20130829194741.ff75bb1ce06207d5d3a703de@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_19_47_41_+1000_s2wjfsFJbCaUOeif"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_19_47_41_+1000_s2wjfsFJbCaUOeif
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc64 defconfig
and others) produced these warnings:

mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
mm/page-writeback.c:1450:13: warning: 'bdi_thresh' may be used uninitialize=
d in this function [-Wuninitialized]
mm/page-writeback.c:1372:16: note: 'bdi_thresh' was declared here
mm/page-writeback.c:1226:16: warning: 'bdi_dirty' may be used uninitialized=
 in this function [-Wuninitialized]
mm/page-writeback.c:1369:16: note: 'bdi_dirty' was declared here

Possibly introduced by commit 34c547af1e23 ("mm/page-writeback.c: add
strictlimit feature"), but I am not sure anything can be done about them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Aug_2013_19_47_41_+1000_s2wjfsFJbCaUOeif
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHxjCAAoJEECxmPOUX5FEWJ4P/3x9Fuu5bcMWuPECFAMQvLW2
U6HgkJh9rmTz1ZMOWwy9I9psVWnZnnnWOMQfnbRjn9aTvh0++56/xAJLLAHjM8qD
+bTNBHrhsmK2mk1ZiK60SDkQTTUWsXKULtufSFWME9O52DYNjA9I1pz9j84odxd2
z1FHIY90P4YXvosdI6eQcvAGoTwqiij0eqR1OX7xurxoQvmqkfxDYrDVwNBpRKlD
wkTdVdkKihX/01i+mElgib0iSUGmTEkwQtxlgbclGJyuGToGgasCWZTNqm9mS+gI
6y896k4xBKFu98cvme98yKqv4+rmmrqaDvG7h+Kn3K3gtaUXqJWmZznQ6P29m2O2
Ct9qWy54vKPYix34O/jgyVf0zRsvgAijsXZheAhnbnv47DCS5dfiMp6Zgbthj+TO
x1GmaLWfYEouEYDISHxPa8951CHEMMAqlB5dLtTZUdzTr26ueqBQAh6U0mqjdmB4
PWNUX7B3vzS0wcYc8A1hS/nG2UBzbYNI9mu/2hqpyc8/3w/1MD3GTMV8Qj+VLa7h
/qJVDVe+BtFkE+xMEWE/BSWBzii6Tyj2Uyzg82/a1L7AGHnsdP1q/y1I1QpvBG/E
0ZMWRLjslQTwSJp0YsM8QcW6ipAUmsRMtcWluqjSFe+hOrKCDJfUOo/vnzCcFvDd
ovK5ukDbpcHGifvBiIeX
=4nd2
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_19_47_41_+1000_s2wjfsFJbCaUOeif--
