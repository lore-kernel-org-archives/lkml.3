Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaBMBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:25:09 -0500
Received: from longford.logfs.org ([213.229.74.203]:42815 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaBMBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:25:08 -0500
Date: Wed, 12 Feb 2014 20:25:48 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, anatol.pomozov@gmail.com, nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
Message-ID: <20140213012548.GA20953@logfs.org>
References: <1392222846-26699-1-git-send-email-mst@redhat.com>
 <1392222846-26699-2-git-send-email-mst@redhat.com>
 <20140212165630.GA22991@kroah.com>
 <20140212.190637.328045386111912135.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140212.190637.328045386111912135.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 February 2014 19:06:37 -0500, David Miller wrote:
> 
> It isn't being used to determine when to destroy things.
> 
> They use it to as a heuristic of when to trigger polling.
> 
> Each ubuf attached gets a kref to the higher level virtio_net buffer
> holding object, they want to trigger polling when that reference drops
> to 1 or lower.
> 
> Right now they are reading the atomic refcount directly, which
> I think is much worse than this helper.

I disagree.  Reading the refcount directly is leaving noone under any
illusion that this might be a good idea.

Jörn

--
Victory in war is not repetitious.
-- Sun Tzu
