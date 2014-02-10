Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaBJSoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:44:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaBJSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:44:19 -0500
Date: Mon, 10 Feb 2014 13:44:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.14
Message-ID: <20140210184412.GA18198@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.14

which is based off v3.13-rc6. If you would like me to rebase it on
a different branch/tag I would be more than happy to do so.

The patches are all bug-fixes and hopefully can go in 3.14.

They deal with xen-blkback shutdown and cause memory leaks
as well as shutdown races. They should go to stable tree and if you
are OK with I will ask them to backport those fixes.

There is also a fix to xen-blkfront to deal with unexpected state
transition. And lastly a fix to the header where it was using the
__aligned__ unnecessarily.

Please pull!


 drivers/block/xen-blkback/blkback.c | 63 ++++++++++++++++++++++++-------------
 drivers/block/xen-blkback/common.h  |  4 ++-
 drivers/block/xen-blkback/xenbus.c  | 13 ++++++++
 drivers/block/xen-blkfront.c        | 11 ++++---
 include/xen/interface/io/blkif.h    | 34 +++++++++-----------
 5 files changed, 79 insertions(+), 46 deletions(-)

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Matt Rushton (1):
      xen-blkback: fix memory leak when persistent grants are used

Roger Pau Monne (3):
      xen-blkback: fix memory leaks
      xen-blkback: fix shutdown race
      xen-blkif: drop struct blkif_request_segment_aligned


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS+R33AAoJEFjIrFwIi8fJpAgH/0TR1KeZMyV3+/c06eNBUGYV
sHOOr9PmfQgMxTL6elHJ/5BPYnVz+VmmyPukb42sH5dcGn/urQt4zwOgZg7SbynJ
RJNcKhnElEute7upiFg8TGj96FeBS3EvwVGHFlXdjJANCrrI6AkFouV7uSXtGYDd
MYd1t1+mX+b+v/SlBXxKwrQ8i+IaBxGb0FsgpAIMo6ATbR8yTXacVoXJGDrs9pmL
tNtQw88vZy638wAuojpuJtNQTM466XXa0GsaVpqbZq5Lw4tErsMvtz4qkqBIP5dN
dQBOK5JIWtDkz6JXlF7oYmoQHw+Ey4ZuF116QYWPdNZ5BvUeSn30ISDvKQuvGcI=
=R7SI
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
