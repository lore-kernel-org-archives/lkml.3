Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3KMIHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:07:39 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:49565 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab3KMIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:07:29 -0500
X-AuditID: 12074424-b7fa56d000000be4-a4-52833340cd6e
Date: Wed, 13 Nov 2013 03:07:26 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] random: fix comment on proc_do_uuid
Message-ID: <20131113080726.GP16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6nrutg3BxksPCZisXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MpY+nozc8EPropHM/cwNjDe4+hi5OSQEDCRePriFTOELSZx4d56
	NhBbSGA2k8S9a7JdjFxA9kZGiTuLzrFCOL8YJfY3TAHrYBFQlfg9qY0VxGYTUJD4MX8dWFxE
	QFli1cxNTCA2M1D8171NYDXCAhYS//Z3g8V5Bcwk3vd9ZoLYZiCxcf8EZoi4oMTJmU9YIHq1
	JG78ewlUwwFkS0ss/wd2NKeAocSkDUfBRooKqEhMObmNbQKj4Cwk3bOQdM9C6F7AyLyKUTYl
	t0o3NzEzpzg1Wbc4OTEvL7VI11wvN7NELzWldBMjOExdVHYwNh9SOsQowMGoxMNrEdMUJMSa
	WFZcmXuIUZKDSUmU10mnOUiILyk/pTIjsTgjvqg0J7X4EKMEB7OSCO8BYaAcb0piZVVqUT5M
	SpqDRUmc9xaHfZCQQHpiSWp2ampBahFMVoaDQ0mC968hUKNgUWp6akVaZk4JQpqJgxNkOA/Q
	cBEjkOHFBYm5xZnpEPlTjIpS4ry5IM0CIImM0jy4XlgaecUoDvSKMK8oSDsPMAXBdb8CGswE
	NNiiuAlkcEkiQkqqgTGXeX0R0/otXntvVWeeEzu9OsK5ecPcfYt3yW8IW/+q8uPfIMNDxtkJ
	GqtWHtRdkK11terQLbu86p3cJ4rfrbZLOMQvuuDa8cba15+LQup317xhczi85eM2r5NK9QpO
	923LNzeuz5itv0w0ZbZT6hP2QOPUvLMWr/nWOxxbm3VJ6dI0KfvDnTpKLMUZiYZazEXFiQCW
	Gm2x/gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one function here now, as uuid_strategy is long gone.
Also make the bit about "If accesses via ..." clearer.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ed72be5..e11ee4e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1516,13 +1516,13 @@ static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
 /*
- * These functions is used to return both the bootid UUID, and random
+ * This function is used to return both the bootid UUID, and random
  * UUID.  The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
  *
- * If the user accesses this via the proc interface, it will be returned
- * as an ASCII string in the standard UUID format.  If accesses via the
- * sysctl system call, it is returned as 16 bytes of binary data.
+ * If the user accesses this via the proc interface, the UUID will be
+ * returned as an ASCII string in the standard UUID format; if via the
+ * sysctl system call, as 16 bytes of binary data.
  */
 static int proc_do_uuid(struct ctl_table *table, int write,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
-- 
1.8.3.2

