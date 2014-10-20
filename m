Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaJTGwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaJTGwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:52:13 -0400
Date: Mon, 20 Oct 2014 09:55:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Denis V. Lunev" <den@openvz.org>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Raushaniya Maksudova <rmaksudova@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v3 0/2] shrink virtio baloon on OOM in guest
Message-ID: <20141020065541.GA16212@redhat.com>
References: <1413388064-5354-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413388064-5354-1-git-send-email-den@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 07:47:42PM +0400, Denis V. Lunev wrote:
> Excessive virtio_balloon inflation can cause invocation of OOM-killer, when
> Linux is under severe memory pressure. Various mechanisms are responsible for
> correct virtio_balloon memory management. Nevertheless it is often the case
> that these control tools does not have enough time to react on fast changing
> memory load. As a result OS runs out of memory and invokes OOM-killer.
> The balancing of memory by use of the virtio balloon should not cause the
> termination of processes while there are pages in the balloon. Now there is
> no way for virtio balloon driver to free memory at the last moment before
> some process get killed by OOM-killer.
> 
> This does not provide a security breach as baloon itself is running
> inside guest OS and is working in the cooperation with the host. Thus
> some improvements from guest side should be considered as normal.
> 
> To solve the problem, introduce a virtio_balloon callback which is expected
> to be called from the oom notifier call chain in out_of_memory() function.
> If virtio balloon could release some memory, it will make the system to
> return and retry the allocation that forced the out of memory killer to run.
> 
> Patch 1 of this series adds support for implementation of virtio_balloon
> callback, so now leak_balloon() function returns number of freed pages.
> Patch 2 implements virtio_balloon callback itself.
> 
> Changes from v2:
> - added feature bit to control OOM baloon behavior from host
> Changes from v1:
> - minor cosmetic tweaks suggested by rusty@
> 
> Signed-off-by: Raushaniya Maksudova <rmaksudova@parallels.com>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Michael S. Tsirkin <mst@redhat.com>

With the feature bit, I think it's fine.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

