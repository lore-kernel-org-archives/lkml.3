Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3FJQB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:01:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3FJQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:01:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH v5] Block backend checks for insane ring entries.
Date: Mon, 10 Jun 2013 12:01:44 -0400
Message-Id: <1370880106-7606-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were posted in the past (v2?) and at which point Jan
Beulich suggested to use a different macro. Unfortunatly after a
more exhaustive testing it was found that said macro is not
appropiate and would needlessly hang up the connection.

Hence re-introducing the new macro which will allow to detect
the producer and consumer indexes being greater than the ring size:

 [v5 1/2] xen/ring: Add a new macro to detect whether there is an

And the patch which will now use it:
 [v5 2/2] xen/blkback: Check for insane amounts of request on the ring


 drivers/block/xen-blkback/blkback.c | 12 +++++++++++-
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 include/xen/interface/io/ring.h     |  6 ++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

Konrad Rzeszutek Wilk (2):
      xen/ring: Add a new macro to detect whether there is an overflow in requests and response.
      xen/blkback: Check for insane amounts of request on the ring (v5).

