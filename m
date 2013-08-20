Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3HTHVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:21:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47120 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HTHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:20:59 -0400
Date: Tue, 20 Aug 2013 17:20:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dwight Engen <dwight.engen@oracle.com>,
        <linuxppc-dev@lists.ozlabs.org>, Gao feng <gaofeng@cn.fujitsu.com>,
        Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        cbe-oss-dev@lists.ozlabs.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Aug_2013_17_20_52_+1000_G/NvKTePrGMPcx_5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Aug_2013_17_20_52_+1000_G/NvKTePrGMPcx_5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/platforms/cell/spufs/inode.c: In function 'spufs_parse_options=
':
arch/powerpc/platforms/cell/spufs/inode.c:623:16: error: incompatible types=
 when assigning to type 'kuid_t' from type 'int'
    root->i_uid =3D option;
                ^
arch/powerpc/platforms/cell/spufs/inode.c:628:16: error: incompatible types=
 when assigning to type 'kgid_t' from type 'int'
    root->i_gid =3D option;
                ^

Caused by commit d6970d4b726c ("enable building user namespace with xfs")
from the xfs tree (that was fun to find :-)).

I have reverted that commit for today.  It could probably be replaced
with a patch that just changed XFS_FS to SPU_FS in the UIDGID_CONVERTED
config dependency - or someone could fix up SPU_FS.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Aug_2013_17_20_52_+1000_G/NvKTePrGMPcx_5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSExjUAAoJEECxmPOUX5FEop4P/1ASCOZV7QRDszGfWJzPIFfx
kr9Xe2WnbIQKbxESqLDO1d2BAjv9E6xtRRS2fe5HPIC1MTwlq+2D9BaZAZd9i0tY
B2xVVr1f6E2G0hl0dCnxXOZo06Ng9FOctUE0UQVN8YhCXni9h+SqckH9FbifdjaW
TooVpCW6j+TyYvjG4Nnm8ax7p/sQQW3UeL6fI/43X3aQ4+dkZEv/oP1YbN+bPsvR
jTWTAo8ZDt003bEDTwjM1MCKx6V16DW0xHqxe7iAPYi26ysJ3UjD7DDRmiUjKSpy
7KVUcqUBc8GLcQDwgf4cL4ozQ4949k0qoWkygoPobBNxu5QFC3rLfKWCp2T8bxii
QCE3kT4+8pCjk5gxv0+6W5Hy1OAcf4odDIrBFzmILko3GcHQxjl0YSKx65PLd6sO
BenoVxdCcWcvecSPcKmR48vZLiZ7jMDMpi0I6u6vM8ANfXDcDQnNZ75EWGlZEakH
Ejq31npT4Yi//zK6DaNdq4zIr7MH3vO5NrjOaz2wXTbA6D76kIPoUPBd3AX881GS
XVK5PV9bRrYe9HVuAcyzqsu4c44NEL2VQFJUA3tcAmLlrEukBdpOTO43Nl73v2fh
QIKOlnsjr0fvP3Nb/Xk53+4HtWkHFiqjb4NhObdbJ7wUZJHl8IhTMmEeo0o+0OXY
GtbSocq6/hU+nq2ISt1q
=/Ph4
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Aug_2013_17_20_52_+1000_G/NvKTePrGMPcx_5--
