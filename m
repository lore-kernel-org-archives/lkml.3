Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaFXDAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:00:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:52981 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaFXDAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:00:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,535,1400050800"; 
   d="asc'?scan'208";a="552321426"
Date: Tue, 24 Jun 2014 10:59:44 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Tiejun Chen <tiejun.chen@intel.com>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to
 check devfn instead of check class type
Message-ID: <20140624025944.GJ1045@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WVXhfWX7iGQecmy9"
Content-Disposition: inline
In-Reply-To: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WVXhfWX7iGQecmy9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014.06.19 17:53:51 +0800, Tiejun Chen wrote:
> Originally the reason to probe ISA bridge instead of Dev31:Fun0
> is to make graphics device passthrough work easy for VMM, that
> only need to expose ISA bridge to let driver know the real
> hardware underneath. This is a requirement from virtualization
> team. Especially in that virtualized environments, XEN, there
> is irrelevant ISA bridge in the system with that legacy qemu
> version specific to xen, qemu-xen-traditional. So to work
> reliably, we should scan through all the ISA bridge devices
> and check for the first match, instead of only checking the
> first one.
>=20
> But actually, qemu-xen-traditional, is always enumerated with
> Dev31:Fun0, 00:1f.0 as follows:
>=20
> hw/pt-graphics.c:
>=20
> intel_pch_init()
>     |
>     + pci_isa_bridge_init(bus, PCI_DEVFN(0x1f, 0), ...);
>=20
> so this mean that isa bridge is still represented with Dev31:Func0
> like the native OS. Furthermore, currently we're pushing VGA
> passthrough support into qemu upstream, and with some discussion,
> we wouldn't set the bridge class type and just expose this devfn.
>=20
> So we just go back to check devfn to make life normal.
>=20
> Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>

This was added historically when supporting graphics device passthrough.
Looks qemu upstream can't accept multiple ISA bridge and our PCH is always
on device 31: func0 as far as I know. Looks good to me.

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--WVXhfWX7iGQecmy9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlOo6aAACgkQsQQaM014GCfsmwCdH/Yhg7VTwHZf+Jrry3AMg9fE
jvIAnjqw/ia/2ySLY9IyoNKpOjKsdTPh
=9D1i
-----END PGP SIGNATURE-----

--WVXhfWX7iGQecmy9--
