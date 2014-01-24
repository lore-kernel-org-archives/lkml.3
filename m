Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaAXFcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:15 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaAXFbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:52 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>,
        "Christopher J. Morrone" <morrone2@llnl.gov>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 3/5] lustre: Account for changelog_ext_rec in CR_MAXSIZE
Date: Thu, 23 Jan 2014 23:45:06 -0500
Message-Id: <1390538708-4120-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CR_MAXSIZE needs to account for an llog_changelog_rec that actually
contains a changelog_ext_rec structure rather than a changelog_rec.
With out doing so, a file size approaching the Linux kernel NAME_MAX
length that is renamed to a size also close to, or at, NAME_MAX will
exceed CR_MAXSIZE and trip an assertion.

Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-on: http://review.whamcloud.com/6993
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3587
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre/lustre_user.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 6b6c0240..7893d83 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -760,7 +760,8 @@ static inline void hsm_set_cl_error(int *flags, int error)
 	*flags |= (error << CLF_HSM_ERR_L);
 }
 
-#define CR_MAXSIZE cfs_size_round(2*NAME_MAX + 1 + sizeof(struct changelog_rec))
+#define CR_MAXSIZE cfs_size_round(2*NAME_MAX + 1 + \
+				  sizeof(struct changelog_ext_rec))
 
 struct changelog_rec {
 	__u16		 cr_namelen;
-- 
1.8.5.3

