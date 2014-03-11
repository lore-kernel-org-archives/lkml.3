Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaCKUrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbaCKUrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:47:10 -0400
Date: Tue, 11 Mar 2014 21:48:28 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
Message-ID: <20140311204826.GA30105@dhcp-26-207.brq.redhat.com>
References: <531DC851.5060400@acm.org>
 <20140311135137.GA22995@dhcp-26-207.brq.redhat.com>
 <531F518A.1070808@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F518A.1070808@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 07:10:18PM +0100, Bart Van Assche wrote:
> > I assume the BUG() above hits? If so, I am failing to understand how
> > the code gets here. Mind elaborate?
> 
> Hello Alexander,
> 
> You are correct, the BUG() mentioned in the call stack in the
> description of this patch does indeed correspond with the BUG()
> statement in the above code. That BUG() was encountered while testing
> the scsi-mq patch series with a workload with a large queue depth. I
> think the fact that I hit that BUG() statement means that my workload
> was queueing requests faster than these were processed by the SCSI LLD
> and hence that percpu_ida_alloc() ran out of tags.

Function steal_tags() is entered with disabled interrupts and
pool->lock taken. Then the 'for' cycle enters/loops while 'cpus_have_tags'
is not zero. Which means we can not end up with no set bits at all -
and that is the reason why BUG() is (legitimately) placed there.

> Bart.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
