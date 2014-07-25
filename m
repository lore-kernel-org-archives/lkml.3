Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaGYJ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:28:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:24130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759312AbaGYJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:28:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,730,1400050800"; 
   d="asc'?scan'208";a="461262478"
Message-ID: <1406280517.17325.3.camel@intelbox>
Subject: Re: [Intel-gfx] [BUG?] 3.16-rc6 ... at
 drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Date: Fri, 25 Jul 2014 12:28:37 +0300
In-Reply-To: <1406158393.13064.1.camel@gmail.com>
References: <1406158393.13064.1.camel@gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-slaistDzv064f+QjbD/x"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-slaistDzv064f+QjbD/x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-07-24 at 01:33 +0200, Ian Kumlien wrote:
> Try four, now including CC lists for the intel driver...

Could you give a try to the 2 patches at:
https://patchwork.kernel.org/patch/4437061/

If these don't fix the issue, could you send a full dmesg log with the
drm.debug=3D14 kernel option set?

Thanks,
Imre

>=20
> ---
>=20
> Hi again,
>=20
>=20
> Playing some more with the new kernel release i noticed this:
> [ 9064.008821] WARNING: CPU: 3 PID: 22929 at drivers/gpu/drm/i915/intel_p=
m.c:5997 intel_display_power_put+0x12d/0x160()
> [ 9064.008822] Modules linked in: uas bnep b43 mac80211 cfg80211 snd_hda_=
codec_hdmi btusb bluetooth 6lowpan_iphc rfkill snd_hda_codec_cirrus uvcvide=
o snd_hda_codec_generic videobuf2_vmalloc videobuf2_memops videobuf2_core s=
nd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer s=
dhci_pci snd sdhci soundcore mmc_core bcma
> [ 9064.008839] CPU: 3 PID: 22929 Comm: kworker/3:2 Tainted: G        W   =
  3.16.0-rc6 #23
> [ 9064.008840] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4=
843, BIOS MBP102.88Z.0106.B03.1211161133 11/16/2012
> [ 9064.008843] Workqueue: events edp_panel_vdd_work
> [ 9064.008844]  0000000000000009 ffff88015ba77d28 ffffffff8198ea2d 000000=
0000000000
> [ 9064.008846]  ffff88015ba77d60 ffffffff810cbac8 ffff8802610b002c 000000=
00000c7204
> [ 9064.008848]  0000000000000001 ffff8802610b80f0 ffff8802610b0000 ffff88=
015ba77d70
> [ 9064.008850] Call Trace:
> [ 9064.008854]  [<ffffffff8198ea2d>] dump_stack+0x4e/0x7a
> [ 9064.008857]  [<ffffffff810cbac8>] warn_slowpath_common+0x78/0xa0
> [ 9064.008858]  [<ffffffff810cbba5>] warn_slowpath_null+0x15/0x20
> [ 9064.008860]  [<ffffffff815bdb3d>] intel_display_power_put+0x12d/0x160
> [ 9064.008862]  [<ffffffff8161e084>] edp_panel_vdd_off_sync+0xf4/0x1c0
> [ 9064.008863]  [<ffffffff8161e17f>] edp_panel_vdd_work+0x2f/0x40
> [ 9064.008866]  [<ffffffff810e63be>] process_one_work+0x16e/0x480
> [ 9064.008868]  [<ffffffff810e6cbb>] worker_thread+0x11b/0x520
> [ 9064.008870]  [<ffffffff810e6ba0>] ? create_and_start_worker+0x50/0x50
> [ 9064.008872]  [<ffffffff810ecb24>] kthread+0xc4/0xe0
> [ 9064.008874]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
> [ 9064.008877]  [<ffffffff81997e6c>] ret_from_fork+0x7c/0xb0
> [ 9064.008878]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
> [ 9064.008880] ---[ end trace 17f9738f20aec288 ]---
> ----
>=20
>=20
> I had multiples of them in my dmesg, however, this seems to fix it:
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel=
_dp.c
> index 8a1a4fb..4c3249d 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1252,6 +1252,7 @@ static void edp_panel_vdd_off_sync(struct intel_dp =
*intel_dp)
>                         intel_dp->last_power_cycle =3D jiffies;
> =20
>                 power_domain =3D intel_display_port_power_domain(intel_en=
coder);
> +               intel_display_power_get(dev_priv, power_domain);
>                 intel_display_power_put(dev_priv, power_domain);
>         }
>  }
> @@ -1371,6 +1372,7 @@ void intel_edp_panel_off(struct intel_dp *intel_dp)
> =20
>         /* We got a reference when we enabled the VDD. */
>         power_domain =3D intel_display_port_power_domain(intel_encoder);
> +       intel_display_power_get(dev_priv, power_domain);
>         intel_display_power_put(dev_priv, power_domain);
>  }
> ---
>=20
>=20
> The question however is: Is this the correct approach? Should it be done
> differently?
> (This handles the "close and open lid" usecase, i don't know if there
> are others, a grep indicated that there might be two more missing...)
>=20
>=20
>=20
>=20
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx


--=-slaistDzv064f+QjbD/x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJT0iNFAAoJEORIIAnNuWDFuvYH/1UHHMnreE/oTLAAkOdGWc95
gceU96e+vvKqHMMOvNqMMBiUYERPMDmbcijKLRR/VvumBAOB6VVmZ3TQX130rx5q
v3Ah7UYN9J3A3OL9set7QpEjVBkxo7S0GqW5dzwRiYCnmUXJdnfT3bTNN498i6Jl
WD4wGeNNy3EYpYPTC2jiP0hfQbVXae1Ghqn1dXbeURIWBGkLVy/PePeYGOoA+swg
IkHnFrN3Ncekzbi82qvt+TPOdHiV9+8gfeOwA5CFjCJki4qJS28GC4pAJgBX8qWt
kwQuKEa1HHpijztvgx4XbwHWOy8aoZULeruZlV14MKoAwQMZR6IHBnUrItGF0gg=
=ESLC
-----END PGP SIGNATURE-----

--=-slaistDzv064f+QjbD/x--

