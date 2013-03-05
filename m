Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab3CEBex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:34:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:24861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab3CEBew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:34:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="asc'?scan'208";a="299027060"
Message-ID: <1362447288.2183.4.camel@jtkirshe-mobl>
Subject: Re: [PATCH  RESEND 2/3] e1000e: fix runtime power management
 transitions
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Mon, 04 Mar 2013 17:34:48 -0800
In-Reply-To: <20130225051907.12689.44621.stgit@zurg>
References: <20130225051010.12689.28611.stgit@zurg>
	 <20130225051907.12689.44621.stgit@zurg>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KAcMB3EP4o0FwBSX6Y8o"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KAcMB3EP4o0FwBSX6Y8o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-25 at 09:19 +0400, Konstantin Khlebnikov wrote:
> This patch removes redundant actions from driver and fixes its
> interaction
> with actions in pci-bus runtime power management code.
>=20
> It removes pci_save_state() from __e1000_shutdown() for normal
> adapters,
> PCI bus callbacks pci_pm_*() will do all this for us. Now
> __e1000_shutdown()
> switches to D3-state only quad-port adapters, because they needs quirk
> for
> clearing false-positive error from downsteam pci-e port.
>=20
> pci_save_state() now called after clearing bus-master bit, thus
> __e1000_resume()
> and e1000_io_slot_reset() must set it back after restoring
> configuration space.
>=20
> This patch set get_link_status before calling pm_runtime_put() in
> e1000_open()
> to allow e1000_idle() get real link status and schedule first runtime
> suspend.
>=20
> This patch also enables wakeup for device if management mode is
> enabled
> (like for WoL) as result pci_prepare_to_sleep() would setup wakeup
> without
> special actions like custom 'enable_wakeup' sign.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |   78
> ++++++----------------------
>  1 file changed, 18 insertions(+), 60 deletions(-)=20

I have added this patch to my e1000e patch queue.

--=-KAcMB3EP4o0FwBSX6Y8o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNUu4AAoJEOVv75VaS+3O9c8P/0nMp41jA5fNrL65MzSFbaAs
cFtLmRp6GrKcaD/R9UGQcZdJaiBH2gB6lxSsHvJev7XRk6coQMfEeAQRyCial9r4
ZRlJBJHs6xnt8A1IBFp4HvTMrKlKwT8Bebj9QOe/SSnVjR8RsS58UdTeXEpjkHEm
ljt+AEu26PD94ZOliA8uJQ4bJaU1iOJeFCZaD41vFcJ+i5QheXXJfVcJOj/4b4d+
7ETEp7ieqsVjWlVWrow2T2yN6qcMklPZG2rUKR/i2YdMl0bnnJ8L7glAuRHCGKAJ
CxPJSEvjOO6wovfANxOIrjIHjol2BNpG4MLFiQJSyAp9m8onYP8jAlLSAkx7peAA
Jj1n8kHdUt8hklZAIugf+Oa+spPJw+hpHHsrqb6cnnUGMfZt7BRYpWKmPC46qgtN
FXmROzVlYFqQAcgsp/BaPvlz7+kkEYlv+uUcc6hn6MrI5Rj/VuirnDNmIDw0QSKP
2FqQJ6bSAVqoEdFmFDkCDaWtCdFTiEgtcIkDGppCQlJmoJn8EX+MDwrMQn9fnDR3
EH4rxWeneVR+gNrrBF0c9cv+YTtiKsOFcItgeHDGdp2g7EnnkGNDbUulp1gFoGzv
LZGDo2ibH3WVziMptQYvnDamDRMUEtoJN0WUeDlqVUVAcODiOLsiO8HtxoVjT/sF
1ixYepf2q1KcSZG/lzmx
=ntAh
-----END PGP SIGNATURE-----

--=-KAcMB3EP4o0FwBSX6Y8o--

