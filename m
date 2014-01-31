Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaAaLrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:47:18 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:64865 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaAaLrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:47:16 -0500
Date: Fri, 31 Jan 2014 06:47:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Yogesh Gaur <yogeshgaur.83@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: Suspected Copy Paste error in rtnl_bridge_notify
Message-ID: <20140131114712.GB26148@htj.dyndns.org>
References: <CAG6enPwAfm8YDrGmEEitv_fHeF5rVVN2nXujh=u4kVy0sKx4ag@mail.gmail.com>
 <CAG6enPyV9bvYSwDrMp6X1LY6PXrmrP5MtjNk0N+7qs1LDY5pRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG6enPyV9bvYSwDrMp6X1LY6PXrmrP5MtjNk0N+7qs1LDY5pRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Seems suspicious but I don't know the code at all.  cc'ing David and
netdev and quoting the whole body for them.

Thanks.

On Fri, Jan 31, 2014 at 11:32:55AM +0530, Yogesh Gaur wrote:
> Hello All,
> 
> I want to clarify about following code-snippet from
> file: "net/core/rtnetlink.c"
> func: rtnl_bridge_notify
> 
> ----------------------------------------------------------------------------
> |    if ((!flags || (flags & BRIDGE_FLAGS_MASTER)) && |
> |        br_dev && br_dev->netdev_ops->ndo_bridge_getlink) {
> |
> |        err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
> |
> |        if (err < 0)
> |
> |            goto errout;
> |
> |    }
> |
> |
> |
> |    if ((flags & BRIDGE_FLAGS_SELF) &&
> |
> |        dev->netdev_ops->ndo_bridge_getlink) {
> |
> |        err = dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
> |
> |        if (err < 0)
> |
> |            goto errout;
> |
> ----------------------------------------------------------------------------
> 
> In above code isn't code line:
> err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
> should be
> err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, br_dev, 0);
> 
> If this needs to be changed then please review attached patch adding this
> change.

-- 
tejun
