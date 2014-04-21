Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaDUOYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:24:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50307 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaDUOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:24:39 -0400
Message-ID: <1398090269.3624.116.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.13 08/32] PCI: Enable INTx in pci_reenable_device()
 only when MSI/MSI-X not enabled
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Mon, 21 Apr 2014 15:24:29 +0100
In-Reply-To: <20140421021135.009538358@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
	 <20140421021135.009538358@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-b7kC8XaBIV8yPepcPocN"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b7kC8XaBIV8yPepcPocN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-04-20 at 19:13 -0700, Greg Kroah-Hartman wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Bjorn Helgaas <bhelgaas@google.com>
>=20
> commit 866d54177b4e671cd52bed1fb487d140d7b691f5 upstream.
>=20
> Andreas reported that after 1f42db786b14 ("PCI: Enable INTx if BIOS left
> them disabled"), pciehp surprise removal stopped working.
>=20
> This happens because pci_reenable_device() on the hotplug bridge (used in
> the pciehp_configure_device() path) clears the Interrupt Disable bit, whi=
ch
> apparently breaks the bridge's MSI hotplug event reporting.
>=20
> Previously we cleared the Interrupt Disable bit in do_pci_enable_device()=
,
> which is used by both pci_enable_device() and pci_reenable_device().  But
> we use pci_reenable_device() after the driver may have enabled MSI or
> MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.
>=20
> This patch clears Interrupt Disable only when MSI/MSI-X has not been
> enabled.
>=20
> Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D71691
> Reported-and-tested-by: Andreas Noever <andreas.noever@gmail.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/pci/pci.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1134,6 +1134,9 @@ static int do_pci_enable_device(struct p
>  	if (dev->msi_enabled || dev->msix_enabled)
>  		return 0;
> =20
> +	if (dev->msi_enabled || dev->msix_enabled)
> +		return 0;
> +

This fix seems to have been applied to two upstream branches and you
have already applied one instance.

Ben.

>  	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
>  	if (pin) {
>  		pci_read_config_word(dev, PCI_COMMAND, &cmd);
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-b7kC8XaBIV8yPepcPocN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU1UqHee/yOyVhhEJAQpSxw//eRaI4yr+vda65tSM5coD7wp52PziC+eL
dH6mhyubPvW8KlBpYGPWoYacI2u46Vy19/8Z8cplc5+eR6TnwHFxEL7+hH60d7eZ
PtyjYxOAOM2KJheQV7sfPBWh9qVnyID4vzHGoZrssi08QhvvdKg6UUPnue8/FG/0
/dXD81hjlyiJwOvRu6jJJp7eU53bVW1dDIqUKvTkJlZbbFoVnulZZGc5DZ7k6gf9
tHL33xRjvflh13Sy5GEL8CQPLlbNsS5icPq1KQQK9KhXHict9wlyJ1ksONYZkfpc
Mvv8Ig6FRuZ+T98TMSWaq2j3/bxONOkk7KtQVksoHH3eKTr6vOeUwpedu22UtMEC
vGdktaPlgPY/2F2INfFge2WVa1aUD0iTtytuLSrfYhXRD9a/GAp4vi0EQRjilF1E
R0Z7RDR1i1TO8Hdk/TwlUamw+Jf2Bgi+QR7RFwRZEjM5PPea72+WVJaRKyLz/8ZW
Nth0zLdKp6nDdKOeIC1OPMiIOAd/hdiwv/kGLtNb8HnKUzCA8O8zjrPonUXP+S8I
Lunb5TVRWegRx2K0la2dKgrfxshOibpQELnp3sihLhPAXISIgzUVDGfkcDKNxU7T
u9okqX0ng/b++kdhR1BJwlUCGvIeMQ1BCoXwoU2z4iWX2u9Qn/hnucJf44yG+oS6
F4tZqeNW8G0=
=oFBd
-----END PGP SIGNATURE-----

--=-b7kC8XaBIV8yPepcPocN--
