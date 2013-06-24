Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3FXC4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 22:56:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40064 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3FXC4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 22:56:13 -0400
Date: Mon, 24 Jun 2013 12:56:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20130624125600.fecd2b8062dfe61b889927d9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Jun_2013_12_56_00_+1000_HKL+yV+zYzNnl83i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Jun_2013_12_56_00_+1000_HKL+yV+zYzNnl83i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_prime.c between commit ebc0bad4a05a ("drm/prime:
Honor requested file flags when exporting a buffer") from Linus' tree and
commit ca793f75d91d ("drm: move pinning/unpinning to buffer attach") from
the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_prime.c
index 5b7b911,d92853e..0000000
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@@ -185,12 -210,8 +210,7 @@@ static const struct dma_buf_ops drm_gem
  struct dma_buf *drm_gem_prime_export(struct drm_device *dev,
  				     struct drm_gem_object *obj, int flags)
  {
- 	if (dev->driver->gem_prime_pin) {
- 		int ret =3D dev->driver->gem_prime_pin(obj);
- 		if (ret)
- 			return ERR_PTR(ret);
- 	}
 -	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size,
 -			     0600);
 +	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size, flags);
  }
  EXPORT_SYMBOL(drm_gem_prime_export);
 =20

--Signature=_Mon__24_Jun_2013_12_56_00_+1000_HKL+yV+zYzNnl83i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRx7VEAAoJEECxmPOUX5FEdyoQAKPSssv8avOCU8oDowSOCe6g
8haE5H/cfXIIEwHNYPpkk2sTxcM9quv1LYE3cQWDI0oC9EHHTE9GMHumTmpZl5Bx
vmdsMEp/sIrEG08YeIeV4S9yfCOTD/XJ8fDV6qgp2dTmOtiJtBB0WGEXiWm8ZhWZ
jQ8GldFzAz7DEAQaadpUqcSJ7uPVomAH6mCOfUqIEIy+m1rVrlpFBFecfb/FMpGb
VT4RYCuiEdeanHkU6JEN2sI6QRia5ZUncJoMDGqjZjtLL6u8BvUte1CZoujC9ffN
h3P/DhhzbJDka3ZAvVWmxDJmURZv4/j1CMip1UqLouVgIt6HvEjRpMKuBtg3cCiF
84wOC43JnlLerDzLnvOE+Zgll2j76JH9+aPM/ebtkz31ag4+mV/9Bh0ral+NcfaY
wr5os4uhxgjWuPR3B78y/rcMJHlYsu8F6+ek/vboBBVG38MaVJBsh5Cx209EAwvo
0qppi/ufiDP5DFdw9u/X2CmAz/i7PGTEO9Fl1olpegPm4yv8Kf5ASC/i7f9PLClc
BiAvv8h6WYvZMDB+D0JrgBV9l1O2H8xALp0yQf8QtiYpSYBZWts/BefQDrrW3lPW
QcfuYQk7JotQEgpl7kPA2pl+vjg2xxn3ACSQLUgM704MB2WgH/O7r8AhwVZDgT9t
OZhRHNu55VbBw6FGjp5W
=rroz
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Jun_2013_12_56_00_+1000_HKL+yV+zYzNnl83i--
