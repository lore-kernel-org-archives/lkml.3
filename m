Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbbA2BPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:15:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34298 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbA2BPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:15:37 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Eddie Kovsky <ewk@edkovsky.org>, Anil Belur <askb23@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: fid: lproc_fid: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:46:28 +0100
Message-Id: <1422485188-10994-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/fid/lproc_fid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 6a21f07..feb7425 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -63,7 +63,6 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
 				    struct lu_seq_range *range)
 {
 	struct lu_seq_range tmp;
-	int rc;
 	char kernbuf[MAX_FID_RANGE_STRLEN];
 
 	LASSERT(range != NULL);
@@ -82,7 +81,7 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
 	}
 
 	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
-	rc = sscanf(kernbuf, "[%llx - %llx]\n",
+	sscanf(kernbuf, "[%llx - %llx]\n",
 		    (unsigned long long *)&tmp.lsr_start,
 		    (unsigned long long *)&tmp.lsr_end);
 	if (!range_is_sane(&tmp) || range_is_zero(&tmp) ||
-- 
1.7.10.4

