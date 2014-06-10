Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaFJTPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaFJTPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:15:02 -0400
Date: Tue, 10 Jun 2014 15:14:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Message-ID: <20140610191453.GD17337@redhat.com>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
 <20140609174708.GA31499@redhat.com>
 <20140609182728.GB31499@redhat.com>
 <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 02:39:06PM -0400, Joe Lawrence wrote:

[..]
> > I am wondering if we need to take a reference on the queue
> > (blk_get_queue()) in blkg_alloc(), to make sure request queue is
> > still around when blkg is being freed.
> 
> I experimented with this and the crash does go away (and the docker
> invocation completes successfully).  I wasn't sure where the
> accompanying blk_put_queue() should go.  If I put it in blkg_free, the
> kref accounting doesn't seem to even out, ie they never fall to zero.

I think blkg_free() is logical place to put down queue reference. I am
not sure why it does not even out. Will spend some time on this. 

> 
> > I will try to reproduce the issue locally.
> 
> Any luck?  I found that slub_debug was required to draw out the crash,
> otherwise the use-after-free silently goes about its business.

I had tried it yesterday and saw the crash out of 3 attempts. I am
right now busy in something. Give me 1-2 days and I will be able to
spend more time on this problem.

Thanks
Vivek
