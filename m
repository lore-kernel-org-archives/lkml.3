Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3KDLtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:49:25 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50297 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752554Ab3KDLtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:49:22 -0500
Date: Mon, 4 Nov 2013 11:28:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
Message-ID: <20131104112840.GC2527@arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
 <20131009101447.GC5985@mudshark.cambridge.arm.com>
 <1381493921.8305.63.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381493921.8305.63.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:18:41PM +0100, Mark Salter wrote:
> On Wed, 2013-10-09 at 11:14 +0100, Will Deacon wrote:
> > > @@ -110,6 +110,7 @@ SECTIONS
> > >                */
> > >               INIT_TASK_DATA(THREAD_SIZE)
> > >               NOSAVE_DATA
> > > +             PAGE_ALIGNED_DATA(PAGE_SIZE)
> > >               CACHELINE_ALIGNED_DATA(64)
> > >               READ_MOSTLY_DATA(64)
> > 
> > Can we just replace this chunk with RW_DATA_SECTION(64, PAGE_SIZE,
> > THREAD_SIZE) instead?
> > 
> 
> I took a look at this. It can be done, but the RW_DATA_SECTION aligns
> data to PAGE_SIZE where the existing alignment is THREAD_SIZE. So using
> RW_DATA_SECTION would waste some space if using 64K pagesize.

I think that's ok, especially since we may get security patches in the
future to create more restrictive page table attributes (well, with the
drawback of more TLB pressure). So I'm for more cleanup in the vmlinux
file by using the generic defines.

-- 
Catalin
