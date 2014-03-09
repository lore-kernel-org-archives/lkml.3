Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaCITTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:19:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52054 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaCITTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:19:19 -0400
Date: Sun, 9 Mar 2014 19:19:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140309191910.139fd91ac440c926cbe94ebe@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__9_Mar_2014_19_19_10_+0000_8v44P9f/qAUhRgur"
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the drm-intel tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__9_Mar_2014_19_19_10_+0000_8v44P9f/qAUhRgur
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in  between c=
ommit 27d50c82714f6 ("ACPI / i915: Fix incorrect <acpi/acpi.h> inclusions v=
ia <linux/acpi_io.h>") from  tree and commit 2fae6a860ca9 ("drm/i915: Go OC=
D on the Makefile") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/gpu/drm/i915/Makefile
index f33902ff2c22,077e81b1065d..b1445b73465b
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@@ -12,49 -23,50 +23,49 @@@ i915-y +=3D i915_cmd_parser.o=20
  	  i915_gem_evict.o \
  	  i915_gem_execbuffer.o \
  	  i915_gem_gtt.o \
+ 	  i915_gem.o \
  	  i915_gem_stolen.o \
  	  i915_gem_tiling.o \
- 	  i915_params.o \
- 	  i915_sysfs.o \
+ 	  i915_gpu_error.o \
+ 	  i915_irq.o \
  	  i915_trace_points.o \
- 	  i915_ums.o \
+ 	  intel_ringbuffer.o \
+ 	  intel_uncore.o
+=20
+ # modesetting core code
+ i915-y +=3D intel_bios.o \
  	  intel_display.o \
- 	  intel_crt.o \
- 	  intel_lvds.o \
- 	  intel_dsi.o \
- 	  intel_dsi_cmd.o \
- 	  intel_dsi_pll.o \
- 	  intel_bios.o \
- 	  intel_ddi.o \
- 	  intel_dp.o \
- 	  intel_hdmi.o \
- 	  intel_sdvo.o \
  	  intel_modes.o \
- 	  intel_panel.o \
- 	  intel_pm.o \
- 	  intel_i2c.o \
- 	  intel_tv.o \
- 	  intel_dvo.o \
- 	  intel_ringbuffer.o \
 -	  intel_opregion.o \
  	  intel_overlay.o \
- 	  intel_sprite.o \
  	  intel_sideband.o \
- 	  intel_uncore.o \
+ 	  intel_sprite.o
 -i915-$(CONFIG_ACPI)		+=3D intel_acpi.o
++i915-$(CONFIG_ACPI)		+=3D intel_acpi.o intel_opregion.o
+ i915-$(CONFIG_DRM_I915_FBDEV)	+=3D intel_fbdev.o
+=20
+ # modesetting output/encoder code
+ i915-y +=3D dvo_ch7017.o \
  	  dvo_ch7xxx.o \
- 	  dvo_ch7017.o \
  	  dvo_ivch.o \
- 	  dvo_tfp410.o \
- 	  dvo_sil164.o \
  	  dvo_ns2501.o \
- 	  i915_gem_dmabuf.o
-=20
- i915-$(CONFIG_COMPAT)   +=3D i915_ioc32.o
-=20
- i915-$(CONFIG_ACPI)	+=3D intel_acpi.o intel_opregion.o
-=20
- i915-$(CONFIG_DRM_I915_FBDEV) +=3D intel_fbdev.o
+ 	  dvo_sil164.o \
+ 	  dvo_tfp410.o \
+ 	  intel_crt.o \
+ 	  intel_ddi.o \
+ 	  intel_dp.o \
+ 	  intel_dsi_cmd.o \
+ 	  intel_dsi.o \
+ 	  intel_dsi_pll.o \
+ 	  intel_dvo.o \
+ 	  intel_hdmi.o \
+ 	  intel_i2c.o \
+ 	  intel_lvds.o \
+ 	  intel_panel.o \
+ 	  intel_sdvo.o \
+ 	  intel_tv.o
 =20
- i915-$(CONFIG_DEBUG_FS) +=3D i915_debugfs.o
+ # legacy horrors
+ i915-y +=3D i915_dma.o \
+ 	  i915_ums.o
 =20
  obj-$(CONFIG_DRM_I915)  +=3D i915.o
 =20

--Signature=_Sun__9_Mar_2014_19_19_10_+0000_8v44P9f/qAUhRgur
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHL6uAAoJELSic+t+oim9yOcP/12dm7X8l1Ag5xXLcTfNF17P
mNMepf2dE+ni+EoyB+3ZPp9jq/rQmldJyw2KOjOt+KjdiiWucDbyeaNVWYZkl2t1
4EBj6Y8EmNXxuyb3COUPUi63JU6Ygu9Hn7OQtSlR8p9bOPn61Ug+IsSj2m3NnxpZ
TmL7b2w3tqnmv8K4R+tnj8My79LEIPvtY8PrBsfo6Y02olocxN8oz8tMIuMtDKuf
3JAPyeHhfGPl6mqv5Z7j8sU2iKJOybhYMrg1bF8wHNkbv8FkC8zveWXkYyCHptf/
TGYN6JHaBrxaXswDXUJ4Tln1u45ze8lEpar2QcJStEhkIs1cr8CZQsJ3+AG+VmIm
ub2POIb/YC5TEdwjnCJi2Rc6UU/Jg2gJiJL5LgXso96J9K55/i0w6NGCvc2oD5TP
i5VeOYiGj3k9Bq3cNDIo0AcOdnQ+uwi1G/9bhkT08NsljqvbKENkeoLd4m/VwEI4
mlweilchviO3/S0oGubZZsIJFSMviHXyePw5BGzgsqwNgH6WNwkxshGf/GUqucwT
Osk7pWQ36GC3H9XHyRG6am9sk5mV8AV6kfq4mZP6KsCBIA1mE39TniX09xDxvyRu
+ac0qrNddMtFR7ELCfFw1A9XTWoHFtWlm85GvQ4FvW6niatN3HhVx29qkYctmxZk
/hOCM1PGwamlTX7SFAqT
=ixBH
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Mar_2014_19_19_10_+0000_8v44P9f/qAUhRgur--
