Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJRUga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 16:36:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:2270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaJRUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 16:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,745,1406617200"; 
   d="scan'208";a="621126754"
Date: Sat, 18 Oct 2014 13:22:07 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 04/21] mm: Allow page fault handlers to perform the
 COW
Message-ID: <20141018172207.GN11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-5-git-send-email-matthew.r.wilcox@intel.com>
 <20141016091136.GC19075@thinkos.etherlink>
 <20141016194815.GD11522@wil.cx>
 <289646725.10903.1413560101974.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <289646725.10903.1413560101974.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 03:35:01PM +0000, Mathieu Desnoyers wrote:
> > > The page fault handler being very much performance sensitive, I'm
> > > wondering if it would not be better to move cow_page near the end of
> > > struct vm_fault, so that the "page" field can stay on the first
> > > cache line.
> 
> Although it's pretty much always true that recent architectures L2 cache
> lines are 64 bytes, I was more thinking about L1 cache lines, which are,
> at least on moderately old Intel Pentium HW, 32 bytes in size (AFAIK
> Pentium II and III).
> 
> It remains to be seen whether we care about performance that much on this
> kind of HW though.

Oh, I just remembered ... this data structure is on the stack, so if it's
not cache-hot, something has gone horribly wrong.

