Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaJPOMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:12:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:40463 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbaJPOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:12:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,732,1406617200"; 
   d="scan'208";a="590182483"
Date: Thu, 16 Oct 2014 10:11:14 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Message-ID: <20141016141114.GB11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141016073908.GA15422@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016073908.GA15422@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 09:39:08AM +0200, Mathieu Desnoyers wrote:
> First of all, thanks a lot for this patchset! Secondly, I must voice out
> that you really need to work on your marketing skills. What your
> changelog does not show is that this feature is tremendously useful
> *today* in the following use-case:
> 
> - On *any* platform for which you can teach the BIOS not to clear memory
>   on soft reboot,
> - Use a kernel argument to restrain it to portion of memory at boot
>   (e.g. 15GB out of 16GB),
> - Create an ext4 or ext2 filesystem in this available memory area,
> - Mount it with DAX flags,

Yes, I definitely suck at technical marketing.  I was thinking that
"NV-DIMMs" were the new hotness, and definitely available today, and
so advertising support for them was the best way to go.  I personally
do use your use case for testing DAX, but it didn't occur to me that
it would have real-world usages.

> >From there, you can do lots of interesting stuff. In my use-case, I
> would love to use it to mmap LTTng kernel/userspace tracer buffers, so
> we can extract them after a soft reboot and analyze a system crash.
> 
> My recommendation would be to rename this patchset as e.g.
> 
> "DAX: Page cache bypass for in-memory persistent filesystems"
> 
> which might attract more interest from reviewers and maintainers, since
> they can try it out today on commodity hardware. Also, pointing out to
> ext4 specifically in the patchset introduction title does not reflect
> the content accurately, since there is also ext2 implementation within
> the series.

Well ... ext2 already has the 'xip' implementation which probably works
well enough for enough of the time.  Most people probably won't hit the
races it has.

> One thing I would really like to see is a Documentation file that
> explains how to setup the kernel so it leaves a memory area free at the
> end of the physical address space, and how to setup a filesystem into
> it. Perhaps it already exists, in this case, pointing to it in the
> patchset introduction changelog would be helpful. (IOW, answering the
> question: how can someone test this today on commodity hardware ?).
> Also, if there are ways to setup pstore or such to achieve something
> similar of a wider range of systems, it would be nice to see
> documentation (or links to doc) explaining how to configure this.

I think that documentation properly belongs to the 'pmem' block driver that
Ross has been posting.  Here's 1/4, which contains some documentation,
but I think you're after something more detailed:

http://marc.info/?l=linux-fsdevel&m=140917398012020&w=2

> I'll try to review your patchset soon, however keeping in mind that it
> would be best to have mm experts having a look into it.

Yes, mm experts have many demands on their time, unfortunately :-(
