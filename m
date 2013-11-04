Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3KDClq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 21:41:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36347 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3KDClo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 21:41:44 -0500
Date: Mon, 4 Nov 2013 13:41:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: build warnings after merge of the modules tree
Message-Id: <20131104134134.48665968dd006e3310333993@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_13_41_34_+1100_iWh.Y3zA.Xc+L+n2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Nov_2013_13_41_34_+1100_iWh.Y3zA.Xc+L+n2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (x86_64
allmodconfig) produced these warning:

WARNING: vmlinux: 'pci_restore_msi_state' exported twice. Previous export w=
as in vmlinux
WARNING: vmlinux: '__mod_zone_page_state' exported twice. Previous export w=
as in vmlinux
WARNING: vmlinux: 'scsi_prep_return' exported twice. Previous export was in=
 vmlinux
WARNING: vmlinux: 'hvc_poll' exported twice. Previous export was in vmlinux
WARNING: vmlinux: 'nfs_clear_inode' exported twice. Previous export was in =
vmlinux

(just some samples ... it scrolled off my scrollback :-()

Presumably caused by commit e0f244c63fc9 ("asmlinkage, module: Make
ksymtab and kcrctab symbols and __this_module __visible").  (reverting
that commit makes the warnings go away.)

I have used the modules tree from next-20131101 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Nov_2013_13_41_34_+1100_iWh.Y3zA.Xc+L+n2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdwljAAoJEMDTa8Ir7ZwV1gEP/28UBHMUrcP7/VVXeOF4pA4l
R5n5W3Ff7TEcMK1liB/FMmu+gudtNSjM8iDTFy8Z8tj0Nmyx4Gx4KLGgrNOuYUPn
hOmH0o7YKGQgSk92f7quJxTFiPPi+aanctDWEQAmbVSGlbZV40vi1zjru7RMuvLy
hjjXFMUf92K8TePLvalrmjcNvHMhJ+t2qvNjFWYEi+Q+entnS5ACbyFnGEk10dHK
0+I/WBJUXaOLf4D/lv6GHKjrU8EhFlbYiVohVW8e+pjuRLGgpw96xhkRHQ0B22sQ
uRNkLkd4rRY2QDRRmXNbXKxnmTxUY5/sPrLt4zTMd7x6BaThl+0NYKwBe822FA7+
A2ABQEvKb+E19mzj9wg6+R4lfXi/ssW+gzjDLum/WOKRiEhkmTub5xhlrRpPGVFJ
4Aix4TH6ebZpz53Y7D1unbyCozE8HJL6hnu2l6sHNatzYDgNGU6TqM+b5Lj8UjdH
sqvUGzmSRgsDHQPvd0/BsqcopHTivJ6u4dSEZ+tBLl31ELG9UQtRHFz/2E3waUVD
M5JGCsX0//0dDaH+qR5h5jIX/Ermg4Qpd+d/aq2Uq4xkMMa93POzbN7q4zXbqtIE
iq+tiq4cM1I4+IoBR2d826+9dNY1Tn+9j8iCtdTjOwta/D6LilFOFhMlfRKLP78d
BQfcrx4015ygolfnrT0E
=29MQ
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_13_41_34_+1100_iWh.Y3zA.Xc+L+n2--
