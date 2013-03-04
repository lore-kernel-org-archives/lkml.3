Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3CDD2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:28:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53639 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3CDD23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:28:29 -0500
Date: Mon, 4 Mar 2013 14:28:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130304142821.b61bd9800c4ea35331829a79@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_14_28_21_+1100_.JcSKTG3uZ/d28tT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_14_28_21_+1100_.JcSKTG3uZ/d28tT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

kernel/built-in.o: In function `console_unlock':
cpu_pm.c:(.text+0x4418): undefined reference to `__bad_udelay'

Caused by commit 4df7323a125f ("printk: avoid softlockups in
console_unlock()") which added

	ndelay(max_interrupt_disabled_duration() / 2);

to console_unlock() which can be a 2.5 second delay ... and the maximum
delayed allowed by udelay (at least in this build) is 2ms.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_14_28_21_+1100_.JcSKTG3uZ/d28tT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNBTVAAoJEECxmPOUX5FEyLAP/Ah/+6IXdcmS/XwB/8axAPLn
oOVZ1sWLXcklUc5fK+P1BvE4oNz/ceACrwqvG2CDuOYZTINd+BXAM3+ChdMCtFF7
yIuBRXNRDFCpxm6fbXmcm/mVBvDCSWdYbG/c4VxGnMEHmWmauqWJUDikr4ofDSe+
Hef48a38l4vmTpy0k20EIbp1Mip4D8cTBc7e+0Q/yeLk4gYES49alL3WPl/0jhU6
uQF3UXUFZO1xlX8gD1GkC2WPBEuDJlmaB0HMzw4XOleGdHnnmgfyQTLm+AsWHMFl
GlmgL0Lke9s/y16uYJno9zGDefbKyYTQBC3zeZ4OrJ1r6auMLMgVWlAf3jsiKrv6
L5QNfpQmPqiOULGjExmjCg2+LM6zX38KPHR71zh/P0D3gKyaeKq3fpCWKZzYIdJo
lLJjNd/HLZ53DYT7B9PXDIAht8w8idUba19jOFKXb9xf6MAMpKkMm+EZD/XNu5zw
jZp+ubLZM8CucO41a6Mcwd2A9u8NFvgY3SIqyLpaCc9Z0s552UBB78WhDT8W6v7p
bO04bZBot3vR+l0IQQNy+d/hVx+smY57YnRzFWFEkN9DPFGr+ZtbqWC9wVZIP5od
hse2z6cRbCGpi8aR2OQCmQduDS84bbGHPJ/Vfach1LgJBw50iO+4PkIhmZfghwNd
XBvUIPU7hTEWc0AruZA8
=4GU4
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_14_28_21_+1100_.JcSKTG3uZ/d28tT--
