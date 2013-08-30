Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3H3ElF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3H3ElC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:41:02 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 0/6] vhost code cleanup and minor enhancement
Date: Fri, 30 Aug 2013 12:29:16 +0800
Message-Id: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series tries to unify and simplify vhost codes especially for
zerocopy. With this series, 5% - 10% improvement for per cpu throughput were
seen during netperf guest sending test.

Plase review.

Changes from V1:
- Fix the zerocopy enabling check by changing the check of upend_idx != done_idx
  to (upend_idx + 1) % UIO_MAXIOV == done_idx.
- Switch to use put_user() in __vhost_add_used_n() if there's only one used
- Keep the max pending check based on Michael's suggestion.

Jason Wang (6):
  vhost_net: make vhost_zerocopy_signal_used() returns void
  vhost_net: use vhost_add_used_and_signal_n() in
    vhost_zerocopy_signal_used()
  vhost: switch to use vhost_add_used_n()
  vhost_net: determine whether or not to use zerocopy at one time
  vhost_net: poll vhost queue after marking DMA is done
  vhost_net: correctly limit the max pending buffers

 drivers/vhost/net.c   |   88 +++++++++++++++++++++----------------------------
 drivers/vhost/vhost.c |   54 +++++++-----------------------
 2 files changed, 50 insertions(+), 92 deletions(-)

