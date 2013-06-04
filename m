Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab3FDHtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:49:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:57262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292Ab3FDHtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="asc'?scan'208";a="323905296"
Date: Tue, 4 Jun 2013 03:42:00 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Betty Dall <betty.dall@hp.com>
Cc: rjw@sisk.pl, bhelgaas@google.com, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from
 aer_hest_parse()
Message-ID: <20130604074159.GB20448@gchen.bj.intel.com>
Mail-Followup-To: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl,
	bhelgaas@google.com, ying.huang@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-2-git-send-email-betty.dall@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <1369924769-17183-2-git-send-email-betty.dall@hp.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 08:39:27AM -0600, Betty Dall wrote:
> Date:	Thu, 30 May 2013 08:39:27 -0600
> From: Betty Dall <betty.dall@hp.com>
> To: rjw@sisk.pl, bhelgaas@google.com
> Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
>  <betty.dall@hp.com>
> Subject: [PATCH v2 1/3] PCI/AER: Fix incorrect return from aer_hest_parse=
()
> X-Mailer: git-send-email 1.7.7.6
>=20
> The function aer_hest_parse() is called to determine if the given
> PCI device is firmware first or not. The code loops through each
> section of the HEST table to look for a match. The bug is that
> the function always returns whether the last HEST section is firmware
> first. The fix stops the iteration once the info.firmware_first
> variable is set.  This is similar to how the function aer_hest_parse_aff()
> stops the iteration.
>=20
> Signed-off-by: Betty Dall <betty.dall@hp.com>

The patch is good. But I have further concern based on your patch.
1) aer_hest_parse never checks the 2nd input parameter (void *data),
which means once it is NULL, it will crash the kernel.

2) both aer_hest_parse and aer_hest_parse_aff utilize some flag
as shortcut, if so, why not adding similar logic in apei_hest_parse
to stop meaningless loops once FFM is confirmed as enabled.

> ---
>=20
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
>=20
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/ae=
rdrv_acpi.c
> index 5194a7d..39b8671 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -42,6 +42,9 @@ static int aer_hest_parse(struct acpi_hest_header *hest=
_hdr, void *data)
>  	u8 bridge =3D 0;
>  	int ff =3D 0;
> =20
> +	if (info->firmware_first)
> +		return 0;
> +
>  	switch (hest_hdr->type) {
>  	case ACPI_HEST_TYPE_AER_ROOT_PORT:
>  		pcie_type =3D PCI_EXP_TYPE_ROOT_PORT;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrZpHAAoJEI01n1+kOSLHfFwP/A4Sz65iCJQCdsdZNiGWC9Ow
4OikR6hhGedkII4aZT1f3XCtibS5+m/O5VG827AhO/6OaWXas7v/HPJDqr9u/fGk
tUFzR2n9yMIcNGBeYuUyp8oDjedov2xqksvbOglXIkcQxB+ZfPVms51HpvxkxE1o
W7ZvHzM3RtFzsDJELnZ5jS0d2M2bt2i+kIsk1xNpNreCvkip5LJiyiJRVTlldTKq
0SMKSvJCOgBAFHdScH5Xzf5fTyQib1W02Qn+sONPB+gbledZMFQJpEvG9ttMid1h
CH/1cTXfePogoTUjSWe0JuMKwFuioy/dCDgH5PqAK+gdLJLoG7a/NQdUZ8xkMfok
DDi8vf4FvPWZ3LRdm62gp0b/Wb3NpfbSIbVaEdBN7sDDlOD2IY5BplW6kuAqDVr1
pIu7sunnyt/iwRCdenSlo4e7G8qz2+4p3jpOxKYAoOQvqV758MbHvaGB8yUNe7MN
ff9yhw+guGKzLoEy/JN+q/iuLxJ1kBCWBYNODAIAb+P3xg6RA+x8HOX+l2xVppaf
fs/K7eb9M8SpaHNVTm1SQHkcL3CSh3c3xEVef60roIgbohQXEKaeouo9lrfOC9Ui
9obeZNab50SAg6MaHQSn5NwjSDxde2dtoTJ3QIo9AGr+Gh3+rbyoAzsPqSozlmxj
HFrWL8cS09Pjpm4cMIBp
=Q9b2
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
