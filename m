Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946357Ab3BHLxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:53:52 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41027
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946329Ab3BHLxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:53:51 -0500
Date: Fri, 8 Feb 2013 12:52:40 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com,
        mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers,
 scatterlist changes
Message-ID: <20130208115240.GN15092@kernel.dk>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
 <8738x7ih5o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738x7ih5o.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2013, Rusty Russell wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> > The virtqueue_add_buf function has two limitations:
> >
> > 1) it requires the caller to provide all the buffers in a single call;
> >
> > 2) it does not support chained scatterlists: the buffers must be
> > provided as an array of struct scatterlist.
> >
> > Because of these limitations, virtio-scsi has to copy each request into
> > a scatterlist internal to the driver.  It cannot just use the one that
> > was prepared by the upper SCSI layers.
> 
> Hi Paulo,
> 
>         Note that you've defined your problem in terms of your solution
> here.  For clarity:
> 
> The problem: we want to prepend and append to a scatterlist.  We can't
>         append, because the chained scatterlist implementation requires
>         an element to be appended to join two scatterlists together.
> 
> The solution: fix scatterlists by introducing struct sg_ring:
>         struct sg_ring {
>                 struct list_head ring;
>         	unsigned int nents;
>         	unsigned int orig_nents; /* do we want to replace sg_table? */
>                 struct scatterlist *sg;
>         };

This would definitely be more flexible than the current chaining.
However:

> The workaround: make virtio accept multiple scatterlists for a single
>         buffer.
> 
> There's nothing wrong with your workaround, but if other subsystems have
> the same problem we do, perhaps we should consider a broader solution?

Do other use cases actually exist? I don't think I've come across this
requirement before, since it was introduced (6 years ago, from a cursory
look at the git logs!).

-- 
Jens Axboe

