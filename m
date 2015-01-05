Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbbAEE2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 23:28:13 -0500
Received: from ozlabs.org ([103.22.144.67]:59868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbbAEE2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 23:28:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC PATCH 0/3] Sharing MSIX irq for tx/rx queue pairs
In-Reply-To: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 05 Jan 2015 12:09:36 +1030
Message-ID: <87ppauovjb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> Hi all:
>
> This series try to share MSIX irq for each tx/rx queue pair. This is
> done through:
>
> - introducing virtio pci channel which are group of virtqueues that
>   sharing a single MSIX irq (Patch 1)
> - expose channel setting to virtio core api (Patch 2)
> - try to use channel setting in virtio-net (Patch 3)

Hi Jason,

        Is "channel" a term you created yourself, or something I was
just unaware of?  irq_group would seem more obvious, if the former.

> For the transport that does not support channel, channel paramters
> were simply ignored. For devices that does not use channel, it can
> simply pass NULL or zero to virito core.
>
> With the patch, 1 MSIX irq were saved for each TX/RX queue pair.

It seems fairly straightforward.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
