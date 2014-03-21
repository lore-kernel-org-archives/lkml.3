Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbaCUJmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760303AbaCUJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:42:10 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC V2 0/4] Adding tracepoints to vhost/net
Date: Fri, 21 Mar 2014 17:41:49 +0800
Message-Id: <1395394913-19548-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent debugging on vhost net zerocopy shows the need of
tracepoints. So to help in vhost{net} debugging and performance
analyzing, the following series adding basic tracepoints to
vhost. Operations of both vhost and vhost_net were traced in current
implementation.

A top-like satistics displaying script were introduced to help the
troubleshooting:
vhost statistics

 vhost_virtio_update_used_idx               1215215       0
 vhost_virtio_get_vq_desc                   1215215       0
 vhost_work_queue_wakeup                     986808       0
 vhost_virtio_signal                         811601       0
 vhost_net_tx                                611457       0
 vhost_net_rx                                603758       0
 vhost_net_tx(datacopy)                      601903       0
 vhost_work_queue_wakeup(rx_net)             565081       0
 vhost_virtio_signal(rx)                     461603       0
 vhost_work_queue_wakeup(tx_kick)            421718       0
 vhost_virtio_update_avail_event             417346       0
 vhost_virtio_signal(tx)                     349998       0
 vhost_work_queue_coalesce                    39384       0
 vhost_work_queue_coalesce(rx_net)            38677       0
 vhost_net_tx(zerocopy)                        9554       0
 vhost_work_queue_coalesce(tx_kick)             707       0
 vhost_work_queue_wakeup(rx_kick)                 9       0

TODO:
- performance test
- finalize which should be traced

Reference:
- V1: https://lkml.org/lkml/2012/4/9/478

Jason Wang (4):
  vhost: introduce queue_index for tracing
  vhost: basic tracepoints
  vhost_net: add basic tracepoints for vhost_net
  tools: virtio: add a top-like utility for displaying vhost satistics

 drivers/vhost/net.c       |   7 +
 drivers/vhost/net_trace.h |  53 +++++++
 drivers/vhost/trace.h     | 175 ++++++++++++++++++++++
 drivers/vhost/vhost.c     |  14 +-
 drivers/vhost/vhost.h     |   3 +
 tools/virtio/vhost_stat   | 375 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 626 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vhost/net_trace.h
 create mode 100644 drivers/vhost/trace.h
 create mode 100755 tools/virtio/vhost_stat

-- 
1.8.3.2

