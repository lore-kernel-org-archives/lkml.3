Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab3JQFEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 01:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3JQFEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 01:04:47 -0400
Date: Thu, 17 Oct 2013 08:07:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug
 notifier if we're not ready
Message-ID: <20131017050710.GA12141@redhat.com>
References: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
 <8738o0aj9u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738o0aj9u.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 09:57:41AM +1030, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
> > We're trying to re-configure the affinity unconditionally in cpu hotplug
> > callback. This may lead the issue during resuming from s3/s4 since
> >
> > - virt queues haven't been allocated at that time.
> > - it's unnecessary since thaw method will re-configure the affinity.
> >
> > Fix this issue by checking the config_enable and do nothing is we're not ready.
> >
> > The bug were introduced by commit 8de4b2f3ae90c8fc0f17eeaab87d5a951b66ee17
> > (virtio-net: reset virtqueue affinity when doing cpu hotplug).
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > The patch is need for 3.8 and above.
> 
> Please put 'CC: stable@kernel.org # 3.8+' in the commit.

Not if this is going in through the net tree.

> 
> (The specification of the stable line is poor, but that seems to be one
> common method).
> 
> Cheers,
> Rusty.
