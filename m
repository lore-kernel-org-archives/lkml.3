Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaEVEJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:09:27 -0400
Received: from ozlabs.org ([103.22.144.67]:54745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaEVEJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:09:26 -0400
Date: Thu, 22 May 2014 14:09:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the pci tree
Message-ID: <20140522140916.1a5f3801@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/itG1h2Xxk33wR7lsq+DwrhN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/itG1h2Xxk33wR7lsq+DwrhN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/pci/pci-sysfs.c: In function 'devspec_show':
drivers/pci/pci-sysfs.c:426:22: error: dereferencing pointer to incomplete =
type
drivers/pci/pci-sysfs.c:428:30: error: dereferencing pointer to incomplete =
type
drivers/pci/pci-sysfs.c:429:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]

Caused by commit da647bb30834 ("PCI: Move Open Firmware devspec
attribute to PCI common code").  Presumably a forgotten include.

I have used the pci tree from next-20140521 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/itG1h2Xxk33wR7lsq+DwrhN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfXhxAAoJEMDTa8Ir7ZwVx5oQAIGGeUjIXRPWmaAkZtSe9OZD
/7FViOW9KDMzrrs/6hjRJN0NvIrRABxmG9s10YL8KMfCeCUGgSPSUpR6zqcFtH2w
Wx4k3qYwGv9UoHMwmN3AdzRe6T42kxQgwR2IO/lkfJrgwyWngvcbsC7oADqUepLK
5RvGIULBm1wzTPWcS9G36pQnyFXB7iX/mUF6Ay7f0pRMm30MCuc1oCP93WT851JB
urGAYitvwb0GRSwE1C2J4EqFYLRIFAcMJYB8U+Qzx2LLOXVe1qNNSQRT5zkADVuy
WcKzypkkl4Usi0xyePRas8E0LahKXmelPsyXXrLYpkhgeqyvcdAvU0eB1pQgHUUx
dvyaPtrkxlrRNorr+pndsWAJqgFbsAMKVPeG0DBFS60E0IUyhOn8evBxz01wDpyO
/ZCwey3f4eEvU8r+lalm4OGL12eSyUwCAB4ClC/qGybuQod3ww7zieVRUqj6A42V
VUzAnxOWOwryCnWcJac16K8BpYMRHv1UuIKjunBvF9GCYwg/Dkkxd4T/PMBIPcfD
Oogbk2aSl+Z41sD75bfjXw9zr+ZAWV5H1JqqAlLp4LQFW25w7ldXUwTpzpGK07JS
a9IirX24vx0mevLr9Aw87hdDl59TP6xhlE+WQBdKl1xOiCYkxIpYhw5SbgGbIVIT
nG/6xpFLxhPPZBRi2m8o
=KYP9
-----END PGP SIGNATURE-----

--Sig_/itG1h2Xxk33wR7lsq+DwrhN--
