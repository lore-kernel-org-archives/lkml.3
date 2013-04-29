Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3D2FpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 01:45:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37319 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3D2FpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 01:45:22 -0400
Date: Mon, 29 Apr 2013 15:45:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20130429154512.13325eb1fe134fbfce93774b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_15_45_12_+1000_=3uQy5uIrnr2OwPH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_15_45_12_+1000_=3uQy5uIrnr2OwPH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/firmware/efi/efivars.c: In function 'efivar_release':
drivers/firmware/efi/efivars.c:300:2: error: implicit declaration of functi=
on 'kfree' [-Werror=3Dimplicit-function-declaration]
drivers/firmware/efi/efivars.c: In function 'efivar_create':
drivers/firmware/efi/efivars.c:341:2: error: implicit declaration of functi=
on 'kzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/firmware/efi/efivars.c:341:12: warning: assignment makes pointer fr=
om integer without a cast [enabled by default]
drivers/firmware/efi/efivars.c: In function 'efivar_create_sysfs_entry':
drivers/firmware/efi/efivars.c:420:13: warning: assignment makes pointer fr=
om integer without a cast [enabled by default]
drivers/firmware/efi/efivars.c: In function 'create_efivars_bin_attributes':
drivers/firmware/efi/efivars.c:460:7: warning: assignment makes pointer fro=
m integer without a cast [enabled by default]
drivers/firmware/efi/efivars.c:470:7: warning: assignment makes pointer fro=
m integer without a cast [enabled by default]
drivers/firmware/efi/efivars.c: In function 'efivar_update_sysfs_entries':
drivers/firmware/efi/efivars.c:527:8: warning: assignment makes pointer fro=
m integer without a cast [enabled by default]
drivers/firmware/efi/efivars.c: In function 'efivars_sysfs_callback':
drivers/firmware/efi/efivars.c:551:8: warning: assignment makes pointer fro=
m integer without a cast [enabled by default]
fs/efivarfs/inode.c: In function 'efivarfs_create':
fs/efivarfs/inode.c:115:2: error: implicit declaration of function 'kzalloc=
' [-Werror=3Dimplicit-function-declaration]
fs/efivarfs/inode.c:115:6: warning: assignment makes pointer from integer w=
ithout a cast [enabled by default]
fs/efivarfs/inode.c:139:3: error: implicit declaration of function 'kfree' =
[-Werror=3Dimplicit-function-declaration]
fs/efivarfs/file.c: In function 'efivarfs_file_write':
fs/efivarfs/file.c:35:2: error: implicit declaration of function 'kmalloc' =
[-Werror=3Dimplicit-function-declaration]
fs/efivarfs/file.c:35:7: warning: assignment makes pointer from integer wit=
hout a cast [enabled by default]
fs/efivarfs/file.c:62:2: error: implicit declaration of function 'kfree' [-=
Werror=3Dimplicit-function-declaration]
fs/efivarfs/file.c: In function 'efivarfs_file_read':
fs/efivarfs/file.c:81:7: warning: assignment makes pointer from integer wit=
hout a cast [enabled by default]
fs/efivarfs/super.c: In function 'efivarfs_callback':
fs/efivarfs/super.c:132:2: error: implicit declaration of function 'kmalloc=
' [-Werror=3Dimplicit-function-declaration]
fs/efivarfs/super.c:132:8: warning: assignment makes pointer from integer w=
ithout a cast [enabled by default]
fs/efivarfs/super.c:142:7: warning: assignment makes pointer from integer w=
ithout a cast [enabled by default]
fs/efivarfs/super.c:166:2: error: implicit declaration of function 'kfree' =
[-Werror=3Dimplicit-function-declaration]
drivers/firmware/efi/efi-pstore.c: In function 'efi_pstore_read_func':
drivers/firmware/efi/efi-pstore.c:77:2: error: implicit declaration of func=
tion 'kmalloc' [-Werror=3Dimplicit-function-declaration]
drivers/firmware/efi/efi-pstore.c:77:16: warning: assignment makes pointer =
from integer without a cast [enabled by default]
drivers/firmware/efi/efi-pstore.c: In function 'efivars_pstore_init':
drivers/firmware/efi/efi-pstore.c:225:22: warning: assignment makes pointer=
 from integer without a cast [enabled by default]

Probably caused by commits d68772b7c83f ("efivarfs: Move to fs/efivarfs")
and/or a9499fa7cd3f ("efi: split efisubsystem from efivars") interacting
with some header inclusion changes in the rest of today's trees.

See Rule 1 from Documentation/SubmitChecklist.

I have applied the following merge fix patch for today (this won't quite
apply to the tip tree due to the other patch adding linux/magic.h to
fs/efivarfs/super.c, but that could be applied as well):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Apr 2013 15:34:28 +1000
Subject: [PATCH] efivars: use of kmalloc etc requires the inclusion of slab=
.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/firmware/efi/efivars.c | 1 +
 fs/efivarfs/file.c             | 1 +
 fs/efivarfs/inode.c            | 1 +
 fs/efivarfs/super.c            | 1 +
 drivers/firmware/efi/efi-pstore.c | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index f8f5e5d..66928a3 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -68,6 +68,7 @@
 #include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/ucs2_string.h>
+#include <linux/slab.h>
=20
 #define EFIVARS_VERSION "0.08"
 #define EFIVARS_DATE "2004-May-17"
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index ede07fc..bfb5315 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -9,6 +9,7 @@
=20
 #include <linux/efi.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
=20
 #include "internal.h"
=20
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 640e289..7e787fb 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
=20
 #include "internal.h"
=20
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1fa5e6d..94d9192 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 #include <linux/magic.h>
=20
 #include "internal.h"
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-p=
store.c
index 221ad1b..0242795 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -2,6 +2,7 @@
 #include <linux/module.h>
 #include <linux/pstore.h>
 #include <linux/ucs2_string.h>
+#include <linux/slab.h>
=20
 #define DUMP_NAME_LEN 52
=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Apr_2013_15_45_12_+1000_=3uQy5uIrnr2OwPH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfgjoAAoJEECxmPOUX5FEYZsP/2Xjb1wkAJ6JfuZZOPQysry1
i9+z+NS6ASBt/H6Jl0CARem4fE7OZFlzdgK4xjJ/40ZfvYbDqjkql9eHfYdVWuzB
W4EWwnD48ZJ/63n5Cj6ADPL15Qy/jn27m4dYhUJ7/MJKsi7Rge1pKdS7kQtZ2TQU
FopPtUqcncMMMMa8u0FMiEn6kGObNnOJ38iNFu5wWf32jDG3KhagC+VjHHkxEzlw
330NBU4WeHR9ZlO7nBsDl6RsP1AyNmtdnDb8usw74UFBHyCHgGYsPIyoY7jgb5LX
9qRGrsYiwbW3OPN9oOrmsqQqU4/xnZesJjJY9QJP7Xh1V7ZkcT3b32YAKvTr6glY
JQZPUGiUO1T9thfdtagl61hbRVI5sYUbLfdah7KRIbEgLiLGc3w96V3DOOq1ljnb
/gKWOAFBMJ9LFTZjouRLwwXTmg3um8gBDzKF7vqZd+UEk+5JP/GoHeCp0jnDTHvV
6y0KLEEu/fBTJJ6m5cCeOkjWJib+N/ryrcnujn2pBGWkMeuwff9iMn9e7BLe3uxj
EzZNg92TGuWvGOF2vigiwwK2ixLp02gq4orlu4n7TxyxKQSFeNF/MnknU/bbSKNU
LGoxGBoZCbMkFOFVLC6jF/7Tq7vNXIjd9Udee2X99msiH0+XQtApS8uB6FEvbQux
1ARX8NoRXVdqbPBe99/1
=35Bn
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_15_45_12_+1000_=3uQy5uIrnr2OwPH--
