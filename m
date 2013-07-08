Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3GHJER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3GHJEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:04:15 -0400
Date: Mon, 8 Jul 2013 12:05:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>
Subject: [PATCH 0/2] virtio_net: fix race in RX VQ processing
Message-ID: <1373274069-4301-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang reported a race in RX VQ processing:
virtqueue_enable_cb is called outside napi lock,
violating virtio serialization rules.
The race has been there from day 1, but it got especially nasty in 3.0
when commit a5c262c5fd83ece01bd649fb08416c501d4c59d7
"virtio_ring: support event idx feature"
added more dependency on vq state.

Please review, and consider for 3.11 and for stable.

Jason, could you please report whether this fixes the issues for you?
