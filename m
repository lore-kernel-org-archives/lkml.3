Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaDVGUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:20:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbaDVGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:20:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29554471"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: [PATCH 0/7 V3] idr: fix & cleanup
Date: Tue, 22 Apr 2014 14:23:22 +0800
Message-ID: <1398147810-26414-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140421152345.4d67a6563ebd89f0b969332f@linux-foundation.org>
References: <20140421152345.4d67a6563ebd89f0b969332f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1 fix a bug caused by overflow.
Patch2,3 add checks for unallocated_id.
Patch4 changes to returned error code
Patch5-7 cleanup.

All patches are acked by Tejun.

Thanks
Lai

Lai Jiangshan (7):
  idr: fix overflow bug during maximum ID calculation at maximum height
  idr: fix unexpected ID-removal when idr_remove(unallocated_id)
  idr: fix NULL pointer dereference when ida_remove(unallocated_id)
  idr: fix idr_replace()'s returned error code
  idr: don't need to shink the free list when idr_remove()
  idr: reduce the unneeded check in free_layer()
  idr: remove useless #ifndef TEST

 lib/idr.c |   42 +++++++++++++++---------------------------
 1 files changed, 15 insertions(+), 27 deletions(-)

-- 
1.7.4.4

