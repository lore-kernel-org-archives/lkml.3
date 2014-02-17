Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaBQCPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 21:15:03 -0500
Received: from ozlabs.org ([203.10.76.45]:57949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaBQCPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 21:15:01 -0500
Date: Mon, 17 Feb 2014 13:14:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: linux-next: manual merge of the libata tree with Linus' tree
Message-Id: <20140217131452.90bef35b57b5cc29e83a0353@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Feb_2014_13_14_52_+1100_iKl4DBO=5hdr+jTj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Feb_2014_13_14_52_+1100_iKl4DBO=5hdr+jTj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the libata tree got a conflict in
drivers/ata/sata_mv.c between commit 90aa2997029f ("ata: sata_mv: Fix
probe failures with optional phys") from Linus' tree and commit
8ad116e649b2 ("ata: sata_mv: Cleanup only the initialized ports") from
the libata tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/sata_mv.c
index 52b8181ddafd,9c1a11de3044..000000000000
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@@ -4131,9 -4129,11 +4130,12 @@@ static int mv_platform_probe(struct pla
  		if (IS_ERR(hpriv->port_phys[port])) {
  			rc =3D PTR_ERR(hpriv->port_phys[port]);
  			hpriv->port_phys[port] =3D NULL;
 -			if ((rc !=3D -EPROBE_DEFER) && (rc !=3D -ENODEV))
 -				dev_warn(&pdev->dev, "error getting phy");
 +			if (rc !=3D -EPROBE_DEFER)
 +				dev_warn(&pdev->dev, "error getting phy %d",
 +					rc);
+=20
+ 			/* Cleanup only the initialized ports */
+ 			hpriv->n_ports =3D port;
  			goto err;
  		} else
  			phy_power_on(hpriv->port_phys[port]);

--Signature=_Mon__17_Feb_2014_13_14_52_+1100_iKl4DBO=5hdr+jTj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTAXChAAoJEMDTa8Ir7ZwVdXgP/R8VCAENaQ5j6fyfj1YuiUTo
2SVcczjXAoiLF7EwQmSbx09R4gCs8Gis9gxeLl7g/X4R4eHtkWJNpvW4PpVuhLlK
zcReExGHaCXv3bysnFH3VyKsqVDUVdG/Htspy4/UC2GxgnPGBU+NpNuCjRYAkJBV
AY4WUBmPebORQtUtSc3TZF1ch5Yez2cg/BG+LJ5zfyqTlxrgRMkuBy6mkmlxL28C
4oYBX590ofGknOjiVn0cB0w4hQIvjxiv8fS6E+LB4mxcpC91SBHltHSkpNpObgA1
2K/ATCLo3BUD7I2ueNTJ+6l/md2FrTRwlHOh5WHSYjpwh7qkAAo7CUf89owEK14U
WYRWyhuqft0yrAolBABUHmu1W7tKqwhWo7Fg5FdEaaq5l87UPTvXEY2IqN1tYdgq
POuBnqakmNqVU9Ni+Q/Z4g08KnoVDPhYi61R3t+WMGkGZm7amZjyr6oK5UllP4E8
XmFywTmZiYI/4FttpiIdUFhEddOHSOKlzyJUdOATeTKPT6gfcDQjaoSQuE8je+00
6f6WYM7cFoOM/y8SjfRvKso5DbaTSp1pqg7A5gr6VjrzsY57kPxAXcwRxP02AoUg
siU8XgMP6QvF4d2vhUdH3tmFhKiDy6VTqNbvLzEHwtIJoRVY6jTjetYyc1k4PzEx
1S8HlbjymiffU9FpISr6
=T3Tm
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Feb_2014_13_14_52_+1100_iKl4DBO=5hdr+jTj--
