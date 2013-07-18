Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3GRE7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:59:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37969 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3GRE7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:59:47 -0400
Date: Thu, 18 Jul 2013 14:59:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the drm-intel tree
Message-Id: <20130718145933.b718b39299efa08b60347539@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_14_59_33_+1000_eT3imVBLpI8dpHXC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_14_59_33_+1000_eT3imVBLpI8dpHXC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit 5cef07e16283 ("drm/i915:
Move active/inactive lists to new mm") from the drm-intel tree and commit
"drivers-convert-shrinkers-to-new-count-scan-api-fix" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index 50e26d3,a56feaa..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -4614,10 -4570,9 +4614,10 @@@ i915_gem_inactive_count(struct shrinke
  			     struct drm_i915_private,
  			     mm.inactive_shrinker);
  	struct drm_device *dev =3D dev_priv->dev;
 +	struct i915_address_space *vm =3D &dev_priv->gtt.base;
  	struct drm_i915_gem_object *obj;
  	bool unlock =3D true;
- 	long cnt;
+ 	unsigned long count;
 =20
  	if (!mutex_trylock(&dev->struct_mutex)) {
  		if (!mutex_is_locked_by(&dev->struct_mutex, current))
@@@ -4629,13 -4584,13 +4629,13 @@@
  		unlock =3D false;
  	}
 =20
- 	cnt =3D 0;
+ 	count =3D 0;
  	list_for_each_entry(obj, &dev_priv->mm.unbound_list, global_list)
  		if (obj->pages_pin_count =3D=3D 0)
- 			cnt +=3D obj->base.size >> PAGE_SHIFT;
+ 			count +=3D obj->base.size >> PAGE_SHIFT;
 -	list_for_each_entry(obj, &dev_priv->mm.inactive_list, mm_list)
 +	list_for_each_entry(obj, &vm->inactive_list, mm_list)
  		if (obj->pin_count =3D=3D 0 && obj->pages_pin_count =3D=3D 0)
- 			cnt +=3D obj->base.size >> PAGE_SHIFT;
+ 			count +=3D obj->base.size >> PAGE_SHIFT;
 =20
  	if (unlock)
  		mutex_unlock(&dev->struct_mutex);

--Signature=_Thu__18_Jul_2013_14_59_33_+1000_eT3imVBLpI8dpHXC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR53Y6AAoJEECxmPOUX5FEkY4P/jiDptRo+3pVbLTNRjDJwAGE
dOnb54ePmaQ+Gk+BydRmDfbwmJk3uTtBqpBdRT0pkT/afXgQN5Q1kd3FdK1nvx+o
EdjadkvT5KuMIjYGQccxa/ULsYw8+0PcyRPsC4+hCrMPLqG5GebH3Te4f32jC2o8
YhbbB00J9Ksa+13OAhUY/LSMaFzuz8M+wDx6qKe2bKAI18OijXM1fjq1kBOynbBS
4Werge9cz6P8I3lNbPxS0mQeEhgnvrf42z5iHPvYQ9x5zaebYH6hXQlMOf/44lM0
MFnSWT7KzQxSVrVW+Zxfwwcl8Sbdj14rnamnvrcCCka/MT9tJYaBH49jI04eF5fE
84VWjuXudczKW29RPqjuPp6SsjY1zSzBnn5jGPC2PwyD5Ghef342QZnvZohEVrww
j17r/uHPZ7kRO/FJzpt595qN/3pfmRiMIkiPAIpHcuOvvnRuZu/3Wo7DsvJSPmKm
E0E7svZEMp7qu8uqX0HSfOscDZrkrPKk5ljGkmfwAClcAozkAvVmIfl1VGgDbB8J
7WAmpLrh+VTYEYimBbpPUgXa3iTEB/f3vz/aCEjs7sZc0XoF4h9M9Oz2ny5hrQCt
bUSsw6StXcwKAipKI/hoRbbg1w2LzCa4c2tCac6d8TDINQtsRivAX4ZVa0x3FqqJ
g9alX9YjFL3MpwkhCV2P
=pYLo
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_14_59_33_+1000_eT3imVBLpI8dpHXC--
