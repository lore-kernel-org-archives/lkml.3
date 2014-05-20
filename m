Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaETGzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:55:22 -0400
Received: from ozlabs.org ([103.22.144.67]:45649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaETGzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:55:18 -0400
Date: Tue, 20 May 2014 16:55:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the dma-buf tree with the drm-intel
 tree
Message-ID: <20140520165511.3f4bdc5d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B1.AD==nBW5qASFl/hRZ5Z2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B1.AD==nBW5qASFl/hRZ5Z2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sumit,

Today's linux-next merge of the dma-buf tree got a conflict in
drivers/gpu/drm/i915/i915_gem_dmabuf.c between commit 5cc9ed4b9a7a
("drm/i915: Introduce mapping of user pages into video memory (userptr)
ioctl") from the drm-intel tree and commit 8dfb1f0f8103 ("dma-buf: use
reservation objects") from the dma-buf tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 580aa42443ed,817ec444c976..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@@ -229,15 -233,8 +229,16 @@@ static const struct dma_buf_ops i915_dm
  struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
  				      struct drm_gem_object *gem_obj, int flags)
  {
 +	struct drm_i915_gem_object *obj =3D to_intel_bo(gem_obj);
 +
 +	if (obj->ops->dmabuf_export) {
 +		int ret =3D obj->ops->dmabuf_export(obj);
 +		if (ret)
 +			return ERR_PTR(ret);
 +	}
 +
- 	return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags);
+ 	return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags,
+ 				NULL);
  }
 =20
  static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *o=
bj)

--Sig_/B1.AD==nBW5qASFl/hRZ5Z2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTevxTAAoJEMDTa8Ir7ZwVH+UP/jh/7K3U2jqRRMdvg7xo9qN5
L0zlAfklKK4lQpxrP2zT2iEuSA3ypDX8WkqjbQ08wP7AskX+ZVJl4D72OF4MGYwG
gM/McVjdEM91vGm93fYxSe0Y4WnVbEuoUNNk71TMHWANG3SDbqjckAsH8DMdaViz
Bg7OFkyX3l6a5osct9OtS/6S6bIU+jAl3O7x4QYIM6Jzoh26yeXW0ohh2QLVdbhb
HNkgiUXpkyNJtghsM64C/FNY8wX29tdd6n207bb0tJ+IzxOYJn/fmiaNBmDUWmYp
KKuZJb12kSVA9D6JLrR91IwXaRmgDCEZeownShVdhVCVoQo8Q6E3huir4AM8M/nF
mTJj1omSXhjQuxowcX+FRl+g/C693jpkOPVraqGAI6HEBryPoe6OBN6IPjxSlkMp
zLZPx15/ywAmPtrPZPoHzQc75eU54sLZ+f+c0a6mH4rnuNMG+1JsySsk18zJ2t8R
AkgljePlV2SJXXscJmEIY4aj0XrYxrC2qNe3TEc5BCFB+teb4fnj1ksA5Z+1zMpz
OhowRBNZxCzYSkG5KX9aZInDVGmncfY2DVTfyC7hxSQzjj+oCRKiatTo7xytoSzA
Xo8QbTZAOAl7BJ6xewobZi2+z/Opdp6vcvNk84OmNXKVXqXCoOl82HK+9ubymXD/
ttMPhJGAltm4+izt6BfY
=hSna
-----END PGP SIGNATURE-----

--Sig_/B1.AD==nBW5qASFl/hRZ5Z2--
