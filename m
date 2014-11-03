Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaKCHvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:51:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaKCHvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:51:14 -0500
Message-ID: <545733ED.2080705@suse.de>
Date: Mon, 03 Nov 2014 08:51:09 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the scsi tree
References: <20141103135229.7916c23c@canb.auug.org.au>
In-Reply-To: <20141103135229.7916c23c@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------070805090102030105050900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070805090102030105050900
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/03/2014 03:52 AM, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/scsi_lib.c: In function 'scsi_io_completion': 
> drivers/scsi/scsi_lib.c:1048:5: error: implicit declaration of
> function 'SCSI_LOG_LEVEL'
> [-Werror=implicit-function-declaration] level =
> SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT, ^
> 
> Caused by commit b6568e80be82 ("scsi: simplify 
> scsi_log_(send|completion)").  SCSI_LOG_LEVEL is defined in 
> drivers/scsi/scsi_logging.h, but only if CONFIG_SCSI_LOGGING is
> defined.
> 
> I have used the version of the scsi tree from next-20141031 for
> today.
> 
Ah, missed that. Here's the patch.

Cheers,

Hannes
- -- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUVzPtAAoJEGz4yi9OyKjPX/YP/2CmPtJDed4+ckb0gjJ8bdlW
i6F532mihXN1WuFYahFujCmZczF8aPEZrViKp/6BZGaqezhqg7BdoH/dXzsYzWAh
Slwlqu52WIj4Eo0B39dN8uuWRPJXV+jvSRE2NucVVhICYYYghR8YhK3HeY2Mw/g7
M1G82a3Ry0g/NpJePzdLImvWj8QoLhua9p61aias0kJjf3p+JskMV3PK9QbroVp/
QsubWkj2yaSs/j21E77JMMzLaQsRK0SIwDvN7AdGxh+h5e9r+eWJrpfdJscAZ4td
FsPApfQR9fxtG9mDPZigf2Oy3XX++N1TPQN6Y7s1KE78d+XGJFxtXEIf1gmp07Pg
lCQACp2WVA14mA+A5PTN7xYtYwvPgMPez63XnAjFkVVXpSMYilRqSPQs82ruN42w
0GGX293ay2s6o1CcFNk/xJp/l7KomKlQbjdIMCkWVbKb3gpO8ivxThPzJv001SN8
zOF7u9YxATQS5EG0Cja9/aLVrhjg0GWFjtmvs9ToSrSgsFrrLycg7zP+DtfP4uz8
2hsAU9Ss9PlxfgbOIMoH42S0YZe4vo6RJmY25POuSfHQVsn+FTVpxqYErMUnNql6
dPfcQq+YqcfcT4n0rBV8VtzRulU11SzNZBEwbJhML4zUs4DCLteemYCWyp/5F+hw
hmmeOMsJfUW8EiLgoLbf
=nK00
-----END PGP SIGNATURE-----

--------------070805090102030105050900
Content-Type: text/x-patch;
 name="0001-scsi-define-SCSI_LOG_LEVEL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-scsi-define-SCSI_LOG_LEVEL.patch"

>From e5c943164a981e32d88c7083c84a85ff513bb0ee Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 3 Nov 2014 08:03:48 +0100
Subject: [PATCH] scsi: define SCSI_LOG_LEVEL

SCSI_LOG_LEVEL needs to be defined even if CONFIG_SCSI_LOGGING
is not enabled.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_logging.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_logging.h b/drivers/scsi/scsi_logging.h
index 1f65139..7fe64a8 100644
--- a/drivers/scsi/scsi_logging.h
+++ b/drivers/scsi/scsi_logging.h
@@ -51,6 +51,7 @@ do {								\
 		} while (0);					\
 } while (0)
 #else
+#define SCSI_LOG_LEVEL(SHIFT, BITS) 0
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
 #endif /* CONFIG_SCSI_LOGGING */
 
-- 
1.8.4.5


--------------070805090102030105050900--
