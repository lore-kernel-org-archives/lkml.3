Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3JCJrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:22 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59834 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3JCJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:46:52 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 3/9] ARM: etm: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:25 +0200
Message-Id: <19b5da63fa3f75504d330c3fc8ead21cc88bd563.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4089-1380793607-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4089-1380793607-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/kernel/etm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8ff0ecd..131a6ab 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -385,7 +385,6 @@ out:
 	return ret;

 out_unmap:
-	amba_set_drvdata(dev, NULL);
 	iounmap(t->etb_regs);

 out_release:
@@ -398,8 +397,6 @@ static int etb_remove(struct amba_device *dev)
 {
 	struct tracectx *t = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	iounmap(t->etb_regs);
 	t->etb_regs = NULL;

@@ -588,7 +585,6 @@ out:
 	return ret;

 out_unmap:
-	amba_set_drvdata(dev, NULL);
 	iounmap(t->etm_regs);

 out_release:
@@ -601,8 +597,6 @@ static int etm_remove(struct amba_device *dev)
 {
 	struct tracectx *t = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	iounmap(t->etm_regs);
 	t->etm_regs = NULL;

--
1.8.2.3


--=_mimegpg-monstr-desktop-4089-1380793607-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPQcACgkQykllyylKDCGqDACfS6kMEBXnh8cQAgFF5rFcyyqc
52kAnRC9quDNITpQDxWA13rOX261WsYx
=NKIm
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4089-1380793607-0001--
