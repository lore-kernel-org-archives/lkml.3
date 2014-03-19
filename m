Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaCSGUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:20:43 -0400
Received: from ozlabs.org ([203.10.76.45]:33871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaCSGUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:20:42 -0400
Date: Wed, 19 Mar 2014 17:20:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Message-Id: <20140319172035.b4e7c4043b486d8eeaa0534a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_17_20_35_+1100_siFwPu9=VL_Yui1F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_17_20_35_+1100_siFwPu9=VL_Yui1F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/net/wireless/iwlwifi/mvm/debugfs.c: In function 'iwl_dbgfs_fw_error=
_dump_release':
drivers/net/wireless/iwlwifi/mvm/debugfs.c:161:2: error: implicit declarati=
on of function 'vfree' [-Werror=3Dimplicit-function-declaration]
  vfree(file->private_data);
  ^

Caused by commit 1bd3cbc1a0e9 ("iwlwifi: mvm: send udev event upon
firmware error to dump logs") from the wireless-next tree.  See Rule 1
from Documentation/SubmitChecklist.

I have reverted that commit (and commit cdb00563fe2c ("iwlwifi: mvm: BT
Coex - add debugfs hook to set BT Tx priority") that may depend on it)
for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Mar_2014_17_20_35_+1100_siFwPu9=VL_Yui1F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKTc3AAoJEMDTa8Ir7ZwV7J0P/ijg3uCXHHnjVuX3a29oMWtB
iAyxUMmABClnq3KDTsT+OkPMcUEqUfIt1Ho9NolDG2S2CV/f9o+GzTr7Hh8cEduL
EVUtHZk5AMp2+hFn0j65Vg+sxmUxHOVerk+LET3+gxBztPi1XZaNy+SZ8PDzzPdc
qafOR8hQVt5+MPlpvx9UJm68Rh22yrdYBexa+j6UlG2fjhm1OZlisahZmPOYKY+p
JmpYPwNuUSg6uomT5oT2Af9StfK/XgKnvMnxAJtY1g07D7WoiFbevBWAvzIbYDl8
LoQ2LCMQBnRxWk9K0xtxdhHsbkgkOIciBgZkcj8JOskGHgyq27MJnXhZaHo/siqe
Fv5CneFlsuBEYCTIaDPxD6fFh1qIELnpQdZRvIUzWfnvJ+di5BVKYvJ+FSH56JOY
/F+7Q18O1x+EOW3upz5VlUPnOb+dAooIXTDugGkCISgv6n+1kZp+2Cr16dC/TaY9
Nr5Piv5gN8yMbbAo9BIXuOswmPnzOV9PR9472JGu9kVp2eErtUBodk+pezinP8QW
Cw6g6NpSadeKp/BPbY1k5v/I2Y8dZeyBTYftb1T3pxSINBiH53snYxSBpF6xrQhn
ZM/1N80fFSKpK1xII6oclizzM/WAqlvnfctcynp09NpWH5FDtb9F0tslvQEFcR5K
oT0myRe6gycAaiB7BmGI
=IrVT
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_17_20_35_+1100_siFwPu9=VL_Yui1F--
