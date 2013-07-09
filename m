Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3GITqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:46:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3GITqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:46:15 -0400
Date: Tue, 09 Jul 2013 12:46:14 -0700 (PDT)
Message-Id: <20130709.124614.1747764332568941574.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, jasowang@redhat.com
Subject: Re: [PATCH v2 0/2] virtio_net: fix race in RX VQ processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373346713-442-1-git-send-email-mst@redhat.com>
References: <1373346713-442-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 9 Jul 2013 08:12:57 +0300

> Jason Wang reported a race in RX VQ processing:
> virtqueue_enable_cb is called outside napi lock,
> violating virtio serialization rules.
> The race has been there from day 1, but it got especially nasty in 3.0
> when commit a5c262c5fd83ece01bd649fb08416c501d4c59d7
> "virtio_ring: support event idx feature"
> added more dependency on vq state.
> 
> Please review, and consider for 3.11 and stable.
> 
> Changes from v1:
> 	- Added Jason's Tested-by tag
> 	- minor coding style fix

Applied and queued up for -stable, thanks.

 
