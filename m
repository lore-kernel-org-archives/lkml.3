Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3KAQSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:18:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58871 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab3KAQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:18:05 -0400
Date: Fri, 1 Nov 2013 16:17:53 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
Message-ID: <20131101161752.GB2442@mudshark.cambridge.arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
 <20131009101447.GC5985@mudshark.cambridge.arm.com>
 <1381493921.8305.63.camel@deneb.redhat.com>
 <1383318090.11574.19.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383318090.11574.19.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:01:30PM +0000, Mark Salter wrote:
> On Fri, 2013-10-11 at 08:18 -0400, Mark Salter wrote:
> > On Wed, 2013-10-09 at 11:14 +0100, Will Deacon wrote:
> > > > @@ -110,6 +110,7 @@ SECTIONS
> > > >                */
> > > >               INIT_TASK_DATA(THREAD_SIZE)
> > > >               NOSAVE_DATA
> > > > +             PAGE_ALIGNED_DATA(PAGE_SIZE)
> > > >               CACHELINE_ALIGNED_DATA(64)
> > > >               READ_MOSTLY_DATA(64)
> > > 
> > > Can we just replace this chunk with RW_DATA_SECTION(64, PAGE_SIZE,
> > > THREAD_SIZE) instead?
> > > 
> > 
> > I took a look at this. It can be done, but the RW_DATA_SECTION aligns
> > data to PAGE_SIZE where the existing alignment is THREAD_SIZE. So using
> > RW_DATA_SECTION would waste some space if using 64K pagesize.
> > 
> > --Mark
> 
> So where do we stand with this one?

I'd probably go for using the generic macro, but I don't have strong
preferences either way.

Will
