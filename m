Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaCQJBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:01:52 -0400
Received: from ozlabs.org ([203.10.76.45]:41120 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbaCQJBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:01:51 -0400
Date: Mon, 17 Mar 2014 20:01:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the powernv-cpuidle tree with the
 powerpc tree
Message-Id: <20140317200143.0ab543c6092e4f6e84ccb9ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_20_01_43_+1100_jFh0IHINV/N.2hpO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_20_01_43_+1100_jFh0IHINV/N.2hpO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the powernv-cpuidle tree got a conflict in
arch/powerpc/platforms/powernv/opal-wrappers.S between commit
c7e64b9ce04a ("powerpc/powernv Platform dump interface") from the powerpc
tree and commit 97eb001f0349 ("powerpc/powernv: Add OPAL call to resync
timebase on wakeup") from the powernv-cpuidle tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/platforms/powernv/opal-wrappers.S
index 47ec3f738062,aab54b60334f..000000000000
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@@ -131,12 -126,7 +131,13 @@@ OPAL_CALL(opal_write_elog,			OPAL_ELOG_
  OPAL_CALL(opal_validate_flash,			OPAL_FLASH_VALIDATE);
  OPAL_CALL(opal_manage_flash,			OPAL_FLASH_MANAGE);
  OPAL_CALL(opal_update_flash,			OPAL_FLASH_UPDATE);
+ OPAL_CALL(opal_resync_timebase,			OPAL_RESYNC_TIMEBASE);
 +OPAL_CALL(opal_dump_init,			OPAL_DUMP_INIT);
 +OPAL_CALL(opal_dump_info,			OPAL_DUMP_INFO);
 +OPAL_CALL(opal_dump_info2,			OPAL_DUMP_INFO2);
 +OPAL_CALL(opal_dump_read,			OPAL_DUMP_READ);
 +OPAL_CALL(opal_dump_ack,			OPAL_DUMP_ACK);
  OPAL_CALL(opal_get_msg,				OPAL_GET_MSG);
  OPAL_CALL(opal_check_completion,		OPAL_CHECK_ASYNC_COMPLETION);
 +OPAL_CALL(opal_dump_resend_notification,	OPAL_DUMP_RESEND);
  OPAL_CALL(opal_sync_host_reboot,		OPAL_SYNC_HOST_REBOOT);

--Signature=_Mon__17_Mar_2014_20_01_43_+1100_jFh0IHINV/N.2hpO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJrn7AAoJEMDTa8Ir7ZwVbA8P/3chAcl9QagyqsZqzXSJh/r+
DSFUpRXVhyUia+BGuf8eFHmbQlhkF3Hcm4scp0PlHZzhRqs4rufU+Gmi4J/hlGiq
9xWuoFsS8BXb/nYzg/ga0qYV2JY34dWqNGNI2cLafb+PVLwBbzjY1G0t41+y89eY
lbReKU+0fQ6M/x8hN1NX1v2swrC9i9SHr64OgQneUXWen2PhbuOubpQh2igNwS+d
Vfxpk4w5iufpsakm5E29l+ifDFgMdC4q5v+fSLXD5nuWQlVL2QHkA9Qu/Sl5XMOa
V+wbsDxfmshUZ8V+ioxyNt3EvHqgWkdIPr2eV5JB5+naM7e0RLPFM7TJGCKU4ySW
QcPfwr1NO7YpWyr6zGfk6xAHsBYOWfRla5uzF5yuUO68FZAe87cAJqXeLWsVwT/y
5DWd/oDpDoN7mmNz8Z5VNLLWRSjDU9ZmLbWimx3ZoIMvTB+QzwbznCG8YFdTBRa5
B6gm4F6NZ3doACwrswDP13u8i/IYs+/ReyL00rlPY8qMQ/Ek/ontu2fM1CgXA5qY
slfvOrkWNzTC/Pt4umJr5x4Uzb0wYtUJyG1Ff9QPVCC8nocwANfCaCCK5kVOodf+
nt/AkM1I8Jd71Il84aNDAjTBSgsKPGSiotxNHhZkVD/6RAvvGes/6YdR3vPAW6pU
IvjHesvelmMaqzEuniHX
=VAKu
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_20_01_43_+1100_jFh0IHINV/N.2hpO--
