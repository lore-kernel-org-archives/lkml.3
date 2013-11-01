Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3KAPBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3KAPBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:01:35 -0400
Message-ID: <1383318090.11574.19.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
From: Mark Salter <msalter@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Date: Fri, 01 Nov 2013 11:01:30 -0400
In-Reply-To: <1381493921.8305.63.camel@deneb.redhat.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
	 <20131009101447.GC5985@mudshark.cambridge.arm.com>
	 <1381493921.8305.63.camel@deneb.redhat.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 08:18 -0400, Mark Salter wrote:
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
> 
> --Mark

So where do we stand with this one?


