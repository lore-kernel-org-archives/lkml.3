Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbaGPIPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:15:44 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58920 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaGPIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:15:40 -0400
Date: Wed, 16 Jul 2014 10:15:37 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <sagar.tv@gmail.com>
Cc: bhelgaas@google.com, rjw@rjwysocki.net, nchumbalkar@lenovo.com,
        swarren@nvidia.com, kthota@nvidia.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, vidyas@nvidia.com
Subject: Re: [PATCH v2] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Message-ID: <20140716081533.GJ7978@ulmo>
References: <1405317877-15060-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <1405317877-15060-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 11:34:37AM +0530, Vidya Sagar wrote:
> From: Vidya Sagar <sagar.tv@gmail.com>

The commit message looks somewhat cluttered:

> 'commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
>  under POWERSAVE mode")'

Usually you'd cite a commit without the extra single quotes. More like
this:

Commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
under POWERSAVE mode") moved...

> moved pcie_aspm_powersave_config_link() out of
> pci_raw_set_power_state() to pci_set_power_state() which would enable
> ASPM. But, with 'commit db288c9c5f9d ("PCI / PM: restore the original
>  behavior of pci_set_power_state()")',

Same here.

>                                        which re-introduced the following =
check
> ./drivers/pci/pci.c: pci_set_power_state()
> +   /* Check if we're already there */
> +   if (dev->current_state =3D=3D state)
> +       return 0;

To make this stand out better, it could be preceded and followed by a
single blank line (and perhaps indented using tabs).

> in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is ne=
ver
> made leaving ASPM broken.
> Fix it by not returning from when the above condition is true, rather, ju=
mp to
> ASPM configuration code and exit from there eventually.
>=20
> Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>

This patch uses code suggested by Bjorn and it's customary to credit the
original author using something like:

	Suggested-by: Bjorn Helgaas <bhelgaas@google.com>

or

	Originally-by: Bjorn Helgaas <bhelgaas@google.com>

Thierry

--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxjSlAAoJEN0jrNd/PrOhueUP+QFQ6cA6SkjxyYNnG/qmPZwA
xH+p5mN+pjsHNAEZVir7k3jBI0CVMTrOCSSOsFuoHGUHHwyBz/CoJdQBDFDc/i3y
RFzMi7P9fG8oongL8IEMWsmPaNBn8pufhwZ4+aSKRmCCzJFb/wMlobhB+coECMSP
unZ7QBORb+zGrKDqoDVditueuFtVCVuJGnN1UglZgn7B8jUAKEXU6QPwhHzH/o0c
24Gc1LD6/WH1VzJhbFvdiuJuSJ/s1fyS+xYKfAXhFybJd9VzpJsEBgtHFsltPPHa
esbqyshpTZ3GiSDL5bbE2Ki4t0uC98BRTgHSdOVaOK9sPvQtr4fOxwm79tUL75j4
Yx76aBRH0yPr9i/uLq/jAmKcbmQu/NsM0q5kAREzkS2YWxChdSy+BuugxavZicKD
eXnh6BLyjbGlkTHNVEhmut6XdN9nsHq60Dh2oFEQolN8GhMsl98w33exyxYkYnkF
665sR7Zcz6YuOdrwwpXKCVV4b8QNh5BpNn+eODiVeqnuTS/q+YVk+/m3xRWjSGYE
d1XAdkoXya0DbWESRui9iHlhaooGtj3GX8f8R0+if1Z9V/lluGO8JUYfK2EPSLv9
fserTjzmDC13E3KGgO++cMF/D7PanVk7KXJCBoxfRNmw+3noUFf2BCWg2TF4LDs9
s9AMwQ0cXpDBmyMzdkjx
=eh10
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
