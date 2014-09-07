Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaIGKSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:18:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50427 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaIGKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:18:49 -0400
Message-ID: <540C3101.40701@redhat.com>
Date: Sun, 07 Sep 2014 12:18:41 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
References: <1410044994-14943-1-git-send-email-hch@lst.de>
In-Reply-To: <1410044994-14943-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2014 01:09, Christoph Hellwig ha scritto:
> Most virtio setups have a fairly limited number of ring entries available.

Are you disabling indirect descriptors?  With indirect descriptors entry
merging doesn't buy you any more space, so perhaps you can key the flag
off the availability of VIRTIO_RING_F_INDIRECT_DESC.

Paolo

> Enable S/G entry merging by default to fit into less of them.  This restores
> the behavior at time of the virtio-blk blk-mq conversion, which was changed
> by commit "block: add queue flag for disabling SG merging" which made the
> behavior optional, but didn't update the existing drivers to keep their
> previous behavior.

