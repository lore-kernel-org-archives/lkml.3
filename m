Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaDRMqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:46:47 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:12149 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752034AbaDRMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:46:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445260"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/8] idr: fix & cleanup
Date: Fri, 18 Apr 2014 20:49:47 +0800
Message-ID: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1 fix a bug caused by overflow.
Patch2,3 add checks for unallocated_id.
Patch4 changes to returned error code
Patch5-8 cleanup.

Lai Jiangshan (8):
  idr: fix overflow bug for the max-high layer
  idr: fix unexpected id-removal when idr_remove(unallocated_id)
  idr: fix NULL pointer dereference when ida_remove(unallocated_id)
  idr: fix idr_replace()'s returned error code
  idr: covert BUG_ON() to WARN_ON_ONCE() if the argument is invalid.
  idr: avoid ping-pong
  idr: don't need to shink the free list when idr_remove()
  idr: reduce the unneeded check in free_layer()

 lib/idr.c |   58 +++++++++++++++++-----------------------------------------
 1 files changed, 17 insertions(+), 41 deletions(-)

-- 
1.7.4.4

