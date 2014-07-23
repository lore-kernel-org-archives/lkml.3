Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbaGWIeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbaGWIeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:34:10 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 net-next 0/2] rx busy polling support for virtio-net
Date: Wed, 23 Jul 2014 16:33:53 +0800
Message-Id: <1406104435-24077-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series introduces the support for rx busy polling support. This
was useful for reduing the latency for a kvm guest. Instead of
introducing new states and spinlocks, this series re-uses NAPI state
to synchonrize between NAPI and busy polling. This grealy simplified
the codes and reduce the overheads of spinlocks for normal NAPI fast
path.

Test was done between a kvm guest and an external host. Two hosts were
connected through 40gb mlx4 cards. With both busy_poll and  busy_read
are set to 50 in guest, 1 byte netperf tcp_rr shows 127% improvement:
transaction rate was increased from 8353.33 to 18966.87.

Changes from V2:
- Avoid introducing new states and spinlocks by reusuing the NAPI
  state
- Fix the budget calculation in virtnet_poll()
- Drop patch 1/3 from V2 since it was useless

Changes from V1:
- split the patch info smaller ones
- add more details about test setup/configuration

Jason Wang (2):
  virtio-net: introduce virtnet_receive()
  virtio-net: rx busy polling support

 drivers/net/virtio_net.c | 67 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 6 deletions(-)

-- 
1.8.3.1

