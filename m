Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaE1Jqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:46:39 -0400
Received: from ozlabs.org ([103.22.144.67]:54547 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbaE1Jqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:46:37 -0400
Date: Wed, 28 May 2014 19:46:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-ID: <20140528194629.0757af1b@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1XbJG+E=GmejHwnvSJahUib"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1XbJG+E=GmejHwnvSJahUib
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c:203:34: error: 'struct ie=
ee80211_hdr' has no member named 'addr1'
           ieee->dev->name, header->addr1);
                                  ^

I can't easily see what caused this, so I just disabled the staging
tree driver:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 May 2014 19:43:17 +1000
Subject: [PATCH] staging: rtl8192u: diable broken driver

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rtl8192u/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kc=
onfig
index 3ee9d0d00fb6..ea5d02d8cca2 100644
--- a/drivers/staging/rtl8192u/Kconfig
+++ b/drivers/staging/rtl8192u/Kconfig
@@ -2,6 +2,7 @@ config RTL8192U
 	tristate "RealTek RTL8192U Wireless LAN NIC driver"
 	depends on PCI && WLAN && USB
 	depends on m
+	depends on BROKEN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select CRYPTO
--=20
2.0.0.rc4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1XbJG+E=GmejHwnvSJahUib
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThbB7AAoJEMDTa8Ir7ZwVB3IP/RRpeZWUVpfxYqX/xhlMWNh1
7pYpXsOGn1qh5uXPdeLzTfgDKhKkIyNPobbS03j4KAvC3op5Dto68W8JVdnG8xMl
x4CPXNjLPLtsgv6nz66BsWaZRhyRPr0fYJpltgjin8BVM3hJTQ94nckPqPJ3XsUE
ncaaT21KTFWAPXBaBCc342l2YVP+I2YbrgvuLEYrLjAuUnKBQeYJO1K6LMYkIXjX
04KHdRHonHqMmkQmAlwH9rdbjpm/xurmkvhNQnXQAKHd2rxToO8o45GNOk8hakVC
dqdtpTBK7s7QAHXWOEGmAa7tRVA/VyLMymNTOaqbsNL2hhlHTwG4G5cRKfCvdmq6
4k5p4jNqWJXKC66HyQTbiaBBz2l6OeKW1QsD7KaH+DOVlgZtXh105KVoHzCUcW9c
AgRmJD53Ncyevb/j5sjBxzB7633RmSW52FOAILnZsJLeTAYKlg6nf2t4jbpHEfDv
1cvXWLRxP7yEPzd1oyAxbw7WDPhFnU2ICHtGsHts6BBQRsn0QR20DvUEs/zZVETG
kSYqwogpkaCNjRI4zt/ydBoVZAntfPDKEpR9HmCp3Y2GOVW+WpfsL8NaO8LrjWpO
xmETFObV11BbIlGp0O1LQiJVP7zOSho+s13YLuZGyxdftxEkJ3ckIP1cvpoHLxkF
COwfP1C4KLiQWuwADXgb
=6y+z
-----END PGP SIGNATURE-----

--Sig_/1XbJG+E=GmejHwnvSJahUib--
