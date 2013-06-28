Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3F1Dap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:30:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33498 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3F1Dao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:30:44 -0400
Date: Fri, 28 Jun 2013 13:30:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20130628133029.d8997882c3e83644e0665027@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Jun_2013_13_30_29_+1000_UlvlBrC9do+pFX=3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Jun_2013_13_30_29_+1000_UlvlBrC9do+pFX=3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next builds (powerpc
ppc64_defconfig and x86_64 allmodconfig) produced this warning:

drivers/video/Kconfig:42:error: recursive dependency detected!
drivers/video/Kconfig:42:	symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:29:	symbol DRM_KMS_HELPER is selected by DRM_OMAP
drivers/gpu/drm/omapdrm/Kconfig:2:	symbol DRM_OMAP depends on FB_OMAP2
drivers/video/omap2/omapfb/Kconfig:1:	symbol FB_OMAP2 depends on FB

Probably revealed by commit dc8de1ae7f59 ("drm/omap: change "!
CONFIG_FB_OMAP2" to "!FB_OMAP2"").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Jun_2013_13_30_29_+1000_UlvlBrC9do+pFX=3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzQNbAAoJEECxmPOUX5FE8A0P/33ZTy/uZIpYVM8imJb4rkCa
W9+K91Aa+uD62TEzw4jo8kUqT4LPSPFX7l/De5ezlwW8/N3gFJ4zhnBZftTnjr2d
1N8H53WPaW83LOwF1xrLszqyQIWQHSQPoFGfc520i37meme11OK+0HVLm/AnIVic
mfYoYkHgg+6hxi4Qx8FTtaWLO8oezoLXsi9duXs6D83scImNHOI69J2QPh6YkhQn
HUa0/5bqLXu6Q6v49p5zyEQySZzHdhA3QrJ6p2iEhQOtp6mDnBXBNhGmtynuBxpk
TgDfgPbbpOCPyOwhX2uVzSoZOsK69pdzBy/XqMu6unQLI+Jy1EkRFbwVG7tRL/So
EQyynizqQ7XEdG6alDy18nm8i0DUChdJZabGdOfLeKVmnb2WZyfi79oRTaKrcnaF
e2+WmkEc0muFEpoa0loQOCmHTmKXfmJgDzdZGqwB/qF9y/jh1RhICwxWuK/RlyQ4
P9qYG3siq50Pk3uGgeyPYhEP8tFHvyIGIOD6ba2ujPUtoFZoQ5T4shHwmIsIqvK7
OvhpjXvTGlyVAsoOzUjHEzh3J7B8bKNueF3WsLZUoYunHViGA6zj15gDhBojz9Be
HNX1r1U/bWP4ODB08n/9uc+VDOMmZfz7CMkYW9AhEb6w9jtnDaWeCJQqnKtyHFdY
28zP4ChoMPPdvY3ArAGi
=7mtg
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Jun_2013_13_30_29_+1000_UlvlBrC9do+pFX=3--
