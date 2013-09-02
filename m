Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3IBIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3IBIwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:52:41 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 0/6] vhost code cleanup and minor enhancement
Date: Mon,  2 Sep 2013 16:40:55 +0800
Message-Id: <1378111261-14826-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series tries to unify and simplify vhost codes especially for
zerocopy. With this series, 5% - 10% improvement for per cpu throughput were
seen during netperf guest sending test.

Plase review.

Changes from V2:
- Typo fixes and code style fix
- Add performance gain in the commit log of patch 2/6
- Retest the update the result in patch 6/6

Changes from V1:
- Fix the zerocopy enabling check by changing the check of upend_idx != done_idx
  to (upend_idx + 1) % UIO_MAXIOV == done_idx.
- Switch to use put_user() in __vhost_add_used_n() if there's only one used
- Keep the max pending check based on Michael's suggestion.

Jason Wang (6):
  vhost_net: make vhost_zerocopy_signal_used() return void
  vhost_net: use vhost_add_used_and_signal_n() in
    vhost_zerocopy_signal_used()
  vhost: switch to use vhost_add_used_n()
  vhost_net: determine whether or not to use zerocopy at one time
  vhost_net: poll vhost queue after marking DMA is done
  vhost_net: correctly limit the max pending buffers

 drivers/vhost/net.c   |   92 ++++++++++++++++++++++--------------------------
 drivers/vhost/vhost.c |   54 ++++++----------------------
 2 files changed, 54 insertions(+), 92 deletions(-)

