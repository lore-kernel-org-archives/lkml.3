Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3FGEYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:24:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab3FGEYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:24:06 -0400
Message-ID: <1370579036.4021.68.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 061/184] PCI/PM: Clean up PME state when removing a device
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Jun 2013 05:23:56 +0100
In-Reply-To: <20130604172132.836205446@1wt.eu>
References: <20130604172132.836205446@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JCceSCIcV2IYm21RAciY"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JCceSCIcV2IYm21RAciY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
>=20
> commit 249bfb83cf8ba658955f0245ac3981d941f746ee upstream.
>=20
> Devices are added to pci_pme_list when drivers use pci_enable_wake()
> or pci_wake_from_d3(), but they aren't removed from the list unless
> the driver explicitly disables wakeup.  Many drivers never disable
> wakeup, so their devices remain on the list even after they are
> removed, e.g., via hotplug.  A subsequent PME poll will oops when
> it tries to touch the device.
>=20
> This patch disables PME# on a device before removing it, which removes
> the device from pci_pme_list.  This is safe even if the device never
> had PME# enabled.

There's no such list in 2.6.32, so I don't think this is needed.

Ben.

> This oops can be triggered by unplugging a Thunderbolt ethernet adapter
> on a Macbook Pro, as reported by Daniel below.
>=20
> [bhelgaas: changelog]
> Reference: http://lkml.kernel.org/r/CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH=
3Gj+8MwevZjDbw@mail.gmail.com
> Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  drivers/pci/remove.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 176615e..27ae1f9 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -19,6 +19,8 @@ static void pci_free_resources(struct pci_dev *dev)
> =20
>  static void pci_stop_dev(struct pci_dev *dev)
>  {
> +	pci_pme_active(dev, false);
> +
>  	if (dev->is_added) {
>  		pci_proc_detach_device(dev);
>  		pci_remove_sysfs_dev_files(dev);

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-JCceSCIcV2IYm21RAciY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFgXOe/yOyVhhEJAQp0lRAAwz6KOM0yctlrghiDcHihBfCKWzGxyEpH
TRB47wwQyOoA/PH2Vos3AH9e65N4NBa+2bkdyEOEgcEdhAiuGU+KnSSKZcM73xHP
3O7QmDR1NP3YslsHDEOi86jYWKI1MPMyroW/fynGuF9R58jdoLObK4uUiqOdo/Qj
fxKW1x+xMeWftW8wLiETBPmn2NkGm6ngcoG5lUk82BfkKMpaFV2Wa3tTtVlQh1C4
vaGNTlrrEUyoZULyRu9uOhMrXpK8dz7ogEP/WzBhSFzrvJ7/RsUK/HmU/LL7cyQp
jnKLD6IeOO/MZ7JgC25g6/ixghsmre7HGEabcRGwsPDEJTPAMy7fEFFjc+LuKvPf
7QGEOKICyJbVmETjOsYYZYPr1oMcw+k11aOJDKkLFMRsbdssK5GkajIZgmY8iFWC
eb3X8YRU7vkmmJ0XsAt0rYVqXXVYHH28vPXTA2mBYwshE30280dPDl5rbuesORRi
rGH8y5WNLP6g/5wMLyrPBWwoWvHb8k1yiR5lykGJKc3nM5sGesCx6vJveezo8FhT
YgHUVC3Tkib1xu1J+FhfHKzVwxn7eZnuHhdP9znIBT3JA10+Tr38X/P9U2U1FwZi
XnBTQ2JGhhZuH/HInFb1n/vqC6m6QSNhUvZfw82OTw1JeaBuZyIcSUXEC4yYtdKB
BB/uqPXbXrY=
=IAon
-----END PGP SIGNATURE-----

--=-JCceSCIcV2IYm21RAciY--
