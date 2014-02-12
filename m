Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaBLP42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaBLP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:56:24 -0500
Date: Wed, 12 Feb 2014 18:01:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Qin Chuanyu <qinchuanyu@huawei.com>
Cc: Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V2 5/6] vhost_net: poll vhost queue after marking DMA is
 done
Message-ID: <20140212160117.GA25440@redhat.com>
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
 <1377836962-49780-6-git-send-email-jasowang@redhat.com>
 <52FB24EA.3060001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB24EA.3060001@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 03:38:18PM +0800, Qin Chuanyu wrote:
> another question is that vhost_zerocopy_callback is called by kfree_skb,
> it may called in different thread context.
> vhost_poll_queue is called decided by ubufs->kref.refcount, this may
> cause there isn't any thread call  vhost_poll_queue, but at least
> one is needed. and this cause network break.
> We could repeat it by using 8 netperf thread in guest to xmit tcp to
> its host.

Thanks a lot for the report, will send the patch soon.

> 
> I think if using atomic_read to decide while do vhost_poll_queue or not,
> at least a spink_lock is needed.

No, nothing so drastic.
