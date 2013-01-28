Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3A1KdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:33:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3A1KdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:33:13 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NMYBiOHLC7exMDWA+beB"
Organization: Red Hat UK Ltd
Date: Mon, 28 Jan 2013 10:31:55 +0000
Message-ID: <1359369115.2697.4.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NMYBiOHLC7exMDWA+beB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fix. Since there is only one patch
this time, I've attached it below rather than posting it separately,

Steve.

---------------------------------------------------------------------------=
---
The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311=
:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

David Teigland (1):
      GFS2: fix skip unlock condition

 fs/gfs2/lock_dlm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)
---------------------------------------------------------------------------=
---
=46rom d4e0bfec9b6fbb9b58640b44e01bb74ae0d29b22 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 3 Jan 2013 17:52:07 -0500
Subject: [PATCH] GFS2: fix skip unlock condition

The recent commit fb6791d100d1bba20b5cdbc4912e1f7086ec60f8
included the wrong logic.  The lvbptr check was incorrectly
added after the patch was tested.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index b906ed1..9802de0 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -281,6 +281,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp =3D gl->gl_sbd;
 	struct lm_lockstruct *ls =3D &sdp->sd_lockstruct;
+	int lvb_needs_unlock =3D 0;
 	int error;
=20
 	if (gl->gl_lksb.sb_lkid =3D=3D 0) {
@@ -294,8 +295,12 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_update_request_times(gl);
=20
 	/* don't want to skip dlm_unlock writing the lvb when lock is ex */
+
+	if (gl->gl_lksb.sb_lvbptr && (gl->gl_state =3D=3D LM_ST_EXCLUSIVE))
+		lvb_needs_unlock =3D 1;
+
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
-	    gl->gl_lksb.sb_lvbptr && (gl->gl_state !=3D LM_ST_EXCLUSIVE)) {
+	    !lvb_needs_unlock) {
 		gfs2_glock_free(gl);
 		return;
 	}
--=20
1.7.4



--=-NMYBiOHLC7exMDWA+beB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRBlOWAAoJEMrg3m4a/8jSV74QAJOIhjKJDuy6MW8PolqC9Tn2
kpKIlI2I4oelCyu/EkUK3T6BCwb+0L30FDDYSYruphZ7hoIwjqkL/4/ugqyiiSZB
sjoQ0aHRdFSbfgJ2j05w6WBi9k/Bn119Hu+JAfhakWaPLlhvLc2vjQo2n0Qa3O8X
duCqy7A6Fmu3bQJYZ592b0Wvq3n4Ll1bimhJ0OE7lV+DuUnLAMn/98HueKpsXRwp
gEghli5LPrW8OwmBJAbdlGuP935lBMhgJxhNZoq783UtJ8DSd4TWIP+f5/SxlBfk
kYMB23FL9rgpQJ0oEwfJrIN6LgHld+YYBzAeSyv8Yz/CfDGjHFngVDXR5Fi30TZn
cu5uelxrFiyyuZcA7luXugKmq2XGcqWfo0NnSb5R4oviIj97RGlMbuqdzUMnP8FS
w0bjO9zmJrMl2YLqPRCUHUvftjEjTjn/kvlLig5GkRQaw52Q8z+xs/+QOu8xcJ76
NoLPdeUqeO7EO6BnctSEN6r4hFLzDoVbZ/VznVzwOQBTRX848ZsaRgPxMZCghYEZ
sVzHgYzMs93eCq1O8SHRtmIQ7KYurRju4A16kjz8WSce43o7y1Ztl7YA87aSrnH/
PhXrlT7fBg2hZ0B899vVQhWM4THtvOwGgBZwU5Ll0pQ0BclA+SZGreDPDhfZWpBO
uAx54Qx++LDJoLXfNc/N
=7GFp
-----END PGP SIGNATURE-----

--=-NMYBiOHLC7exMDWA+beB--

