Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3GIFLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3GIFLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:11:48 -0400
Date: Tue, 9 Jul 2013 08:12:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>
Subject: [PATCH v2 0/2] virtio_net: fix race in RX VQ processing
Message-ID: <1373346713-442-1-git-send-email-mst@redhat.com>
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

Please review, and consider for 3.11 and stable.

Changes from v1:
	- Added Jason's Tested-by tag
	- minor coding style fix

