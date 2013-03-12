Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3CLEWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:22:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39224 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3CLEWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:22:37 -0400
Date: Tue, 12 Mar 2013 15:22:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: build failure after merge of the final tree (drm-intel
 tree related)
Message-Id: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_15_22_26_+1100_NNMI2/vr3RuM2wep"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_15_22_26_+1100_NNMI2/vr3RuM2wep
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

drivers/built-in.o: In function `i915_min_freq_set':
i915_debugfs.c:(.text+0xb1adc): undefined reference to `__udivdi3'
drivers/built-in.o: In function `i915_max_freq_set':
i915_debugfs.c:(.text+0xb1bac): undefined reference to `__udivdi3'

Caused by commit 2389cc500686 ("drm/i915: use simple attribute in debugfs
routines") from the drm-intel tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_15_22_26_+1100_NNMI2/vr3RuM2wep
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPq2CAAoJEECxmPOUX5FE9yEP/1QOXjz7hiY8M6R1/kY7pB0w
MD4kkHVnH0salYMyifNLFVBAs2mSOg8icY8ud2LtqC/6si5SqPA3My0MIOAMRkY6
jPELBxV1i2vPUfDZATQ7ykOAB4SesiOGqBroqZoy9UeKiCDqu1yXdRSo5heT0Rhu
nsKFMPPPIbvceSfa1had/x4wJcc8j/yOpl+Wig4cStpU8ffnIp7qOrNosguqbOA3
8B3hXs5q+RqvECr9Cgu/tMOayTejRNmw6Hn8VVdCYsiAfyI/tmv+qjs8MjqBmD1a
+V0hiByiJ1PIhrMI0S09S5/cOlSyu4+UClbSkSskFE6nWTDUSjnU3C0ok492H6m3
4ZHaHz9MMVKWhtKq1n4KBXWJvylJn58HX3QYsJTl292AcXEhu3GT8BI7P/ftl19N
7q4U/FD9x722LggZqoufwD/TBbiR6igEQdqedYgjcTMuehyL2QqbV4Nq3dKDy0C0
aIODH7CBYyhzg8P1y8yrDORg8DfzIuiOoIvPAxT4RP2m0dGdXWz+IaPErwKbo8oP
3buyJ8TwOGrfv9sVKbNiHr9APTi3nfFxCscn7FEpdukeyQ5q5ofJMEDllyucpuOc
gyZ0dH6RuGtPnohXVGyWsUsUNj7r0Ax3MiVdGKPrDcgwqsVKrfP48yiuAUCb2VzY
3qn4d8GUDAEtPx3Vjcvi
=1uDu
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_15_22_26_+1100_NNMI2/vr3RuM2wep--
