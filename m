Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaDSLel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:34:41 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55869 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751367AbaDSLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:34:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,888,1389715200"; 
   d="scan'208";a="29471745"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/9 V2] idr: fix & cleanup
Date: Sat, 19 Apr 2014 19:38:07 +0800
Message-ID: <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch1 fix a bug caused by overflow.
Patch2,3 add checks for unallocated_id.
Patch4 changes to returned error code
Patch5-9 cleanup.


Lai Jiangshan (9):
  idr: fix overflow bug during maximum ID calculation at maximum height
  idr: fix unexpected ID-removal when idr_remove(unallocated_id)
**^^also consider ida_remove()
  idr: fix NULL pointer dereference when ida_remove(unallocated_id)
  idr: fix idr_replace()'s returned error code
  idr: covert BUG_ON() to WARN_ON_ONCE() if the argument is invalid.
**^^move the test into ida_remove() as tj suggested.
  idr: avoid ping-pong
  idr: don't need to shink the free list when idr_remove()
**^^split
  idr: reduce the unneeded check in free_layer()
  idr: remove useless C-PreProcessor branch
**^^new

 lib/idr.c |   66 +++++++++++++++++++++---------------------------------------
 1 files changed, 23 insertions(+), 43 deletions(-)

-- 
1.7.4.4

