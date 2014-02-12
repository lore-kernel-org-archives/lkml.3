Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBLQdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:33:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaBLQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:33:03 -0500
Date: Wed, 12 Feb 2014 18:37:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        davem@davemloft.net, qinchuanyu@huawei.com
Subject: [PATCH net 0/3] vhost fixes for 3.14, -stable
Message-ID: <1392222846-26699-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a deadlock with vhost reported in the field,
as well as a theoretical race issue found by code
review.

Patches 1+2 are needed for stable.

Thanks to Qin Chuanyu for reporting the issue!

Michael S. Tsirkin (3):
  kref: add kref_sub_return
  vhost: fix ref cnt checking deadlock
  vhost: fix a theoretical race in device cleanup

 include/linux/kref.h | 33 ++++++++++++++++++++++++++++++++-
 drivers/vhost/net.c  | 15 ++++++++++-----
 2 files changed, 42 insertions(+), 6 deletions(-)

-- 
MST
