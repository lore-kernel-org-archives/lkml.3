Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbaGOKVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:21:52 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46368 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOKVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:21:49 -0400
Message-ID: <1405419703.10255.26.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next] virtio-net: rx busy polling support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>
Date: Tue, 15 Jul 2014 12:21:43 +0200
In-Reply-To: <1405417265-13103-1-git-send-email-jasowang@redhat.com>
References: <1405417265-13103-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 17:41 +0800, Jason Wang wrote:
> Add basic support for rx busy polling.
> 
> 1 byte netperf tcp_rr on mlx4 shows 116% improvement: the transaction
> rate was increased from 9151.94 to 19787.37.

This is a misleading changelog.

You forgot to describe how you allowed busy polling, as it is not
'automatic'

If not, this patch adds two spinlock/unlock pairs in fast path.

Also, it looks like you could split this in smaller patches.

virtnet_napi_disable_all() & virtnet_napi_enable_all() could be added in
a separate patch for example.



