Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaJAWwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:52:44 -0400
Received: from ozlabs.org ([103.22.144.67]:33962 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaJAWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:52:41 -0400
Date: Thu, 2 Oct 2014 08:52:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: linux-next: manual merge of the vfio tree with the pci tree
Message-ID: <20141002085233.286f6f22@canb.auug.org.au>
In-Reply-To: <1412183174.7360.218.camel@ul30vt.home>
References: <20141001131421.64cab8d7@canb.auug.org.au>
	<1412183174.7360.218.camel@ul30vt.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/koEWQpYk3jxHyRKlaw8rv6B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/koEWQpYk3jxHyRKlaw8rv6B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Wed, 01 Oct 2014 11:06:14 -0600 Alex Williamson <alex.williamson@redhat.=
com> wrote:
>
> On Wed, 2014-10-01 at 13:14 +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the vfio tree got a conflict in
> > drivers/pci/msi.c between commits a160fe94cb53 ("PCI/MSI: Remove unused
> > get_cached_msi_msg()") and 18ef822c59f6 ("PCI/MSI: Rename
> > __get_cached_msi_msg() to get_cached_msi_msg()") from the pci tree and
> > commit 3b307ffe3faa ("PCI: Export MSI message relevant functions") from
> > the vfio tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).  And then I added this merge fix patch (I should probably
> > also have added an include of linux/irq.h):
>=20
> Thanks for the heads-up and manual merge.  I've reviewed the changes to
> the MSI API that got us into this conflict and I disagree with them.
> I've posted a series to revert a selection of changes currently coming
> in through pci/next that should make for a clean merge should Bjorn come
> to the same conclusion.  If you need to re-apply the fix in the
> meantime, please do include <linux/irq.h> since it generated a build
> failure on arm without it.  Thanks!

Seems Bjorn has removed the conflicting commits from the pci tree.
Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/koEWQpYk3jxHyRKlaw8rv6B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULIW2AAoJEMDTa8Ir7ZwVRQsP/i82deFQM2mp11Gsw66sKzs1
Akus/Sk/NTyuBRprodWRm64XwtJJmb3gSHFsEZqK1C4ZNSRMxIgB6XV7GboRN5ux
EGPj/mmCOWaLy3yceZHAOgKYZdIVBChuORiWxn9SsR/UyPgEm03zsDAx+A8LSZk8
9L1HHv4Q9+sNG1FRMScUe84a5TzVQn/95eG+ZgeGeLkSuuMBsvjhyx055wXAKsGc
P1bVhNbO3qyyEWyVJA9TlN3LoCiOwabEjWqECnsBq+P5b/P5wepwzS9cGXL1gQ6r
4NSVwK6uvv5expk9kWPDWLKWl4oCWJBn4KcwHKUBO7SNV0Pc+0M0iGCkEU3p3YWw
2620mEzF1bR0dnVHKrpzIQEL1dJrtWjEK8EsAirUSI4k7Ih5lj/TgOGl8l4brGLQ
n5zwFDgmo/7dmizVXzTk8++419i/bnNLbewgXieT0WXo3a84PF0QmO4SLRpcf0LD
tKlXhf7x0R4z9RgEDW740tW7TlqGAl6bxzTgLFsjYi9hig32kGeewgKdH9hRUMBW
JD4HPvJkJuZm59pWllrivAsmI4pFBXyPMFAdXs67FMxHCwqgfT3bElevuMaJXbZM
7yr4XY6t92Av1EjR/aRUSbe9njP2eIhQBn7yxSTgj38CMC48hRZtapnUvTaBciAC
zm3UxAUb3Ihhj0IYWEiq
=4Y1N
-----END PGP SIGNATURE-----

--Sig_/koEWQpYk3jxHyRKlaw8rv6B--
