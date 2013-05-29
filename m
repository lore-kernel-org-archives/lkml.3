Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab3E2LCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:02:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49453 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965628Ab3E2LCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:02:02 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-89-51a5e028097c
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org,
        Phil Carmody <phil.carmody@partner.samsung.com>
Subject: [PATCH] checkpatch: forgive use of mixed case variables measuring units
Date: Wed, 29 May 2013 14:02:50 +0300
Message-id: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xy7oaD5YGGtz8qWjxYa2Gxez7j1ks
	Lu+aw2ax+9VSVgcWj1kNvWweB9/tYfL4suoas8fnTXIBLFFcNimpOZllqUX6dglcGdtaNzEX
	dLFV7Lo2k7GB8SlLFyMHh4SAicSBte5djJxAppjEhXvr2boYuTiEBJYySnxs6mSEcLqYJH5M
	Os4IUsUmYCoxZcU3JhBbREBNoqVnGjuIzSwQLPH47QxmEFtYIEDi4snHYDUsAqoSdza/AbN5
	geJbGs8zQSxWkJgzyWYCI/cCRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGe/7KDcfEx
	q0OMAhyMSjy8gV+XBAqxJpYVV+YeYpTgYFYS4U0VXBooxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gXHZuZTtzIJLrQI/JN6w5DhTr8R/xLD1kn9MDOOjWO8NAXMbbmxm0zom4scqv9VkNVPACcY8
	D6+73BKzazzF3i4zkJHwvWc+pWo5L/P2qcz729P5ypLfZ6Vt1o/mzng39ZFe41Xm+6azLXYu
	UK2pLZI9uerO93nmZ47eZF+uHnR0L8P8JWf9ViuxFGckGmoxFxUnAgBlj+V82gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think anyone really has an issue with things like max_mV.
And whilst nS et al. may not be SI standard, at least it's clear
what they represent.

Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
---
 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..c29fd2f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2940,6 +2940,7 @@ sub process {
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /^[a-z_]*_[numk][VAS]$/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
-- 
1.7.9.5

