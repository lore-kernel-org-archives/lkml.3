Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaJGX3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:29:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbaJGXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 35/37] vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()
Date: Tue,  7 Oct 2014 16:19:52 -0700
Message-Id: <20141007231828.128880317@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 83da7510058736c09a14b9c17ec7d851940a4332 upstream.

Seems to be called with preemption enabled.  Therefore it must use
mod_zone_page_state instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1144,7 +1144,7 @@ unsigned long reclaim_clean_pages_from_l
 			TTU_UNMAP|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
 }
 


