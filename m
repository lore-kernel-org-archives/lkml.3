Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203Ab3JQD6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:58:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57046 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3JQD6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:58:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug notifier if we're not ready
In-Reply-To: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
References: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 17 Oct 2013 09:57:41 +1030
Message-ID: <8738o0aj9u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> We're trying to re-configure the affinity unconditionally in cpu hotplug
> callback. This may lead the issue during resuming from s3/s4 since
>
> - virt queues haven't been allocated at that time.
> - it's unnecessary since thaw method will re-configure the affinity.
>
> Fix this issue by checking the config_enable and do nothing is we're not ready.
>
> The bug were introduced by commit 8de4b2f3ae90c8fc0f17eeaab87d5a951b66ee17
> (virtio-net: reset virtqueue affinity when doing cpu hotplug).
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch is need for 3.8 and above.

Please put 'CC: stable@kernel.org # 3.8+' in the commit.

(The specification of the stable line is poor, but that seems to be one
common method).

Cheers,
Rusty.
