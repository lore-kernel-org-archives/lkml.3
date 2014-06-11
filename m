Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaFKCDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:03:04 -0400
Received: from ozlabs.org ([103.22.144.67]:60510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbaFKCDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:03:03 -0400
Date: Wed, 11 Jun 2014 12:02:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Desfosses <ryan@desfo.org>
Subject: linux-next: build failure after merge of the pci tree
Message-ID: <20140611120249.56a64953@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Hi/5dUDwwaz_YidG2sgYPqN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Hi/5dUDwwaz_YidG2sgYPqN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:


ERROR: ".pci_try_set_mwi" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
ERROR: ".pci_clear_mwi" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
ERROR: ".pci_try_set_mwi" [drivers/scsi/lpfc/lpfc.ko] undefined!

Caused by commit 9259d755975f ("PCI: Move EXPORT_SYMBOL so it
immediately follows function/variable").
arch/powerpc/include/asm/pci.h defines PCI_DISABLE_MWI and there are
two version of those functions depending on the setting of that symbol.

I have used the pci tree from next-20140610 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Hi/5dUDwwaz_YidG2sgYPqN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTl7jOAAoJEMDTa8Ir7ZwVjpIP/3pcxUMJwa3k1Q0soTvAC7gM
JCf/dDV57bGp/7jWywObOA4Yp7Q0rUNWvxf+TgoUHXYQxCrR79/cVnz5iw77V4Pz
4hsnZGn8LBAsJf839NvNSwnsxbUXL9i76T5QKiTjeOuBKNUxQG+HrR6bT+/kuhjQ
cgX5OqFW33Z+9hOT9ZhbCnxEcitPLAVsBsZAKbGq58E9TNEqDt98o0HUM5BfNk0z
2wfwA6MeFpAgBPTkgLNUcBvJY7B0EKSJDLOFRSNf3sMdPk8GrpA5F8V3oJwnghMu
vs98nkIUHOCD/b/DHvrlGsLAquZDXvT/9rOziPz7LfQ1PNePlL/gSbkliC7ZoQK9
ltU8S0DrhHcnc704fgL7L5bT/F/eLCnTBhCdt9U/yHAjx/0ts3uVPRbWxzsfINkU
rh3rD3ncCZNjqfiGHXiK+UuP2u86gfaA3sTTAAlKKFzNBMHb+MP/KFf+X/cUfz0l
JKMva7LrYLopO1rPJREKUSWzmlKxJ7SMPHhjr22Cx5vQJWJ8S6gNAxUwhQ1ezPp2
1VnyopCC302kCWv2oLgzcSdlQdWHuZsS+T/vSOFwbl4U/4GhmH0DwVFMUzFL+xHM
SYkpCtKZOasKCcR20jJRENP6UiD9P1VtF096iuq6uFgAn2/XILfZxgj763+yvGoo
IpcgnF3v4bXJHJ7D998F
=PPlQ
-----END PGP SIGNATURE-----

--Sig_/Hi/5dUDwwaz_YidG2sgYPqN--
