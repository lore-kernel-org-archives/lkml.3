Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaJOGeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:34:02 -0400
Received: from ozlabs.org ([103.22.144.67]:45941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaJOGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net-next RFC 1/3] virtio: support for urgent descriptors
In-Reply-To: <1413011806-3813-2-git-send-email-jasowang@redhat.com>
References: <1413011806-3813-1-git-send-email-jasowang@redhat.com> <1413011806-3813-2-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 16:10:02 +1030
Message-ID: <877g01c2ml.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> Below should be useful for some experiments Jason is doing.
> I thought I'd send it out for early review/feedback.
>
> event idx feature allows us to defer interrupts until
> a specific # of descriptors were used.
> Sometimes it might be useful to get an interrupt after
> a specific descriptor, regardless.
> This adds a descriptor flag for this, and an API
> to create an urgent output descriptor.
> This is still an RFC:
> we'll need a feature bit for drivers to detect this,
> but we've run out of feature bits for virtio 0.X.
> For experimentation purposes, drivers can assume
> this is set, or add a driver-specific feature bit.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

The new VRING_DESC_F_URGENT bit is theoretically nicer, but for
networking (which tends to take packets in order) couldn't we just set
the event counter to give us a tx interrupt at the packet we want?

Cheers,
Rusty.
