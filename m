Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3CUOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab3CUOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:49:47 -0400
Date: Thu, 21 Mar 2013 10:49:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130321144929.GH3934@redhat.com>
References: <87txo5bxk4.fsf@xmission.com>
 <20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
 <8738vp75cy.fsf@xmission.com>
 <20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
 <87y5dhw71o.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5dhw71o.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:22:59AM -0700, Eric W. Biederman wrote:
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
> > OK, rigorously, suceess or faliure of the requested free pages
> > allocation depends on actual memory layout at the 2nd kernel boot. To
> > increase the possibility of allocating memory, we have no method but
> > reserve more memory for the 2nd kernel now.
> 
> Good enough.   If there are fragmentation issues that cause allocation
> problems on larger boxes we can use vmalloc and remap_vmalloc_range, but
> we certainly don't need to start there.
> 
> Especialy as for most 8 or 16 core boxes we are talking about a 4KiB or
> an 8KiBP allocation.  Aka order 0 or order 1.
> 

Actually we are already handling the large SGI machines so we need
to plan for 4096 cpus now while we write these patches.

vmalloc() and remap_vmalloc_range() sounds reasonable. So that's what
we should probaly use.

Alternatively why not allocate everything in 4K pages and use vmcore_list
to map offset into right addresses and call remap_pfn_range() on these
addresses.

Thanks
Vivek
