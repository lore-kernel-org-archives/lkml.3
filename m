Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaFWLbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:31:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46211 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752466AbaFWLbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:31:19 -0400
Date: Mon, 23 Jun 2014 12:31:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: export __cpu_{clear,copy}_user_page functions
Message-ID: <20140623113108.GE15907@arm.com>
References: <1403025266-2326-1-git-send-email-msalter@redhat.com>
 <20140618103954.GC14680@arm.com>
 <1403099643.32688.30.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403099643.32688.30.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:54:03PM +0100, Mark Salter wrote:
> On Wed, 2014-06-18 at 11:39 +0100, Catalin Marinas wrote:
> > On Tue, Jun 17, 2014 at 06:14:26PM +0100, Mark Salter wrote:
> > > The __cpu_clear_user_page() and __cpu_copy_user_page() functions
> > > are not currently exported. This prevents modules from using
> > > clear_user_page() and opy_user_page().
> > > 
> > > Signed-off-by: Mark Salter <msalter@redhat.com>
> > > ---
> > >  arch/arm64/mm/copypage.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> > > index 9aecbac..13bbc3be 100644
> > > --- a/arch/arm64/mm/copypage.c
> > > +++ b/arch/arm64/mm/copypage.c
> > > @@ -27,8 +27,10 @@ void __cpu_copy_user_page(void *kto, const void *kfrom, unsigned long vaddr)
> > >  	copy_page(kto, kfrom);
> > >  	__flush_dcache_area(kto, PAGE_SIZE);
> > >  }
> > > +EXPORT_SYMBOL_GPL(__cpu_copy_user_page);
> > >  
> > >  void __cpu_clear_user_page(void *kaddr, unsigned long vaddr)
> > >  {
> > >  	clear_page(kaddr);
> > >  }
> > > +EXPORT_SYMBOL_GPL(__cpu_clear_user_page);
> > 
> > I wonder why we still have these functions. I don't think we need any
> > D-cache flushing for copy_user_page(), so we could simply remove this
> > code and define copy_user_page() as copy_page() (similarly for
> > clear_user_page). I'll post a patch separately removing the copy_page,
> > copy_user_page etc. functions (now that we also have optimised memcpy
> > and memset).
> 
> Even better. I much prefer removing code than adding it. Thanks.

For the time being I'll merge your patch since using memset for
clear_page adds a small overhead with checking the alignment and the
fill value (not much but consistently slower in my mmap benchmarks).

-- 
Catalin
