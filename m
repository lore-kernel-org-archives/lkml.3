Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaE1IDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:03:48 -0400
Received: from ozlabs.org ([103.22.144.67]:36904 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaE1IDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:03:44 -0400
Date: Wed, 28 May 2014 18:03:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Jean Delvare <jdelvare@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140528180331.4abb99a0@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UrJOmG74htSC.AFH=cJ9Ob0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UrJOmG74htSC.AFH=cJ9Ob0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/crypto/nx/nx-842.c: In function 'nx842_probe':
drivers/crypto/nx/nx-842.c:1200:6: error: void value not ignored as it ough=
t to be
  if (dev_set_drvdata(&viodev->dev, rcu_dereference(devdata))) {
      ^

Caused by commit 2c1f1ff0f0d9 ("driver core: dev_set_drvdata returns
void").  Grep is better than hope :-)

I have used the driver-core tree from next-20140527 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UrJOmG74htSC.AFH=cJ9Ob0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThZhXAAoJEMDTa8Ir7ZwVikgP/2w1JtwwVlH6FdTHZNZqcoH2
MD4pCk2xazMjCZSdr7jdSBC1o9e6+/u/f/Wo/zoJ+F80v1V9rvlLVruLUYDCvNTs
pB0xTxPkmV8J0X+ujzR5EevVTCpwvCBBpvbczZuqy7mCL8vLdax5bgcFTzjUN/cK
m29BGlwKW+XHAa+DAzTQUeOuZzaQv+o9AdImoGlJAkJFIOfpDZLyw5i4bGcw72Oe
1NUxxC5+w8ARmdtb6EoYLpnqXldYoPa/Nc4huWiQjgCWmP6Kk/aKWK+9EVz0Tojs
VI3LqzVPM202wmt9S1jdN3BeZOA/Sw+a4UMNEXoc3wdfPE047xHbFOix8tQw7ktD
2LcNJeXqBtZIHDAV6jfSySavDRxAgi0s+ZtXIKBmNbpt+6lDXwbBMMMBByE1iuMQ
bY9ce7lQ/7LMxhmn/rTXnyWKpHEdLFm1j5NkLkBwJaHfzpAn4GMVVtGOUhNgQOkc
t1/7lFMnWfVuDyKHk9CzUgVnJh+F70FPeO9tPt4aBmLf99aktsNFELT4BiErYQBg
arwYL/v8oBXMFiSSOlQ1GRhhTjBrws6fhkkkeezQj2F9jvHOqfkZAFd6VK7r/GgR
dE99xYMBXOQ2jzS+oZ0X1FozGHdzZXRE3KLotDyG8kjKCT7iYAxQoczrwkMe5z53
9Us7BdfkLk/PmHMEF7yL
=/Brq
-----END PGP SIGNATURE-----

--Sig_/UrJOmG74htSC.AFH=cJ9Ob0--
