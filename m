Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaBYEZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:25:59 -0500
Received: from ozlabs.org ([203.10.76.45]:49900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbaBYEZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:25:57 -0500
Date: Tue, 25 Feb 2014 15:25:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>, Jason Cooper <jason@lakedaemon.net>,
        <andrew@lunn.ch>, <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: linux-next: manual merge of the watchdog tree with the mvebu tree
Message-Id: <20140225152548.65ba8372349800898f109fb2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_15_25_48_+1100_MXBf+t4kBYf2hc9Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Feb_2014_15_25_48_+1100_MXBf+t4kBYf2hc9Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/orion_wdt.c between commit e97662e1e28d ("watchdog:
orion: Handle the interrupt so it's properly acked") from the mvebu tree
and commit 2e9a2ff49520 ("watchdog: delete non-required instances of
include <linux/init.h>") from the watchdog tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/orion_wdt.c
index 15321aa0bb94,498163497c1c..000000000000
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@@ -18,9 -18,8 +18,8 @@@
  #include <linux/kernel.h>
  #include <linux/platform_device.h>
  #include <linux/watchdog.h>
- #include <linux/init.h>
 +#include <linux/interrupt.h>
  #include <linux/io.h>
 -#include <linux/spinlock.h>
  #include <linux/clk.h>
  #include <linux/err.h>
  #include <linux/of.h>

--Signature=_Tue__25_Feb_2014_15_25_48_+1100_MXBf+t4kBYf2hc9Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDBtQAAoJEMDTa8Ir7ZwV4NAP/RNgUFh3F2TsQNi1spyluMmk
G41rjWky0pL3WCqcTcCuCRbOf0DskfAo6HUL6R9Jy8moYp0mbr7+WWK9O0VGpxsC
lvBVkN9B91dc0GpPoaIIV8DqWwDbVwZFNwBSsbIuj/HLnB7maSucFDunZ2ADoeso
pAiXj7Lc/n7WunLdYRmv0KQhm5ZMZlqgqBS38Q1xua3POS7LwPG7cYZVSmZ0Fl+s
cUkV9C5Kd8UxMi4gALEfFeXEj5oIv6ZPfqHKbco5bwAGQlmm7vyqCwzNsii6qBF2
bMcQDGYrUMD1zS6WsbqZAsUM0B8Cux4sxgYAhJsvQcW9eQizlsuoLGZCrVOFPF0f
7SpLa0pAWmCq0dPwfKm9wILKzpwS1bBgnLMIzZG7fDXdyRdO8Ugp5xGaPZBhM5sf
OTT2r3+/Zr6/zjBp9sp+FJprt6sE37IiQ5PTJx6xCe11LFLn5n81rKTHJzsjvni5
Fr/TNu3HfHuIfgOZaf2oo9Pp82U7bUC/jgz+R+jZvgu2jAGs1RG/TyMSrvEdWZ93
xuF/Kyl3Hdj/J4yqk1XCH2Ze71KvLGrPWZu4FBnOXGz6HRPqHXYcyxZMyVZlaHRw
pdRWAm3C74AGI9YTX2sn7aOILxnUeJ+CyTqolBJzHicSDPRuHGWaSyfS71zpyDoJ
3tTl3jNHSGFOvTan3HMh
=wbrG
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_15_25_48_+1100_MXBf+t4kBYf2hc9Y--
