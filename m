Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbaEMIgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:36:46 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48508 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbaEMIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:36:10 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, mimu@linux.vnet.ibm.com,
        ddongch@cn.ibm.com
Subject: [PATCH v1] vhost: avoid large order allocations
Date: Tue, 13 May 2014 10:35:32 +0200
Message-Id: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051308-0542-0000-0000-000008F79172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A test case which generates memory pressure while performing guest administration
fails with vhost triggering "page allocation failure" and guest not starting up.

After some analysis we discovered the allocation order of vhost to be rensponsible
for this behaviour. Thus we suggest patch 1/1 which dynamically allocates the
required memory. Please see its description for details.

Thanks,
Michael 

Dong Dong Chen (1):
  vhost: avoid large order allocations

 drivers/vhost/net.c   | 4 ++--
 drivers/vhost/scsi.c  | 4 ++--
 drivers/vhost/test.c  | 2 +-
 drivers/vhost/vhost.c | 6 +++++-
 drivers/vhost/vhost.h | 2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

-- 
1.8.3.1

