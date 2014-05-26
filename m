Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaEZNiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:38:22 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:52431 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaEZNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <53834310.8060808@redhat.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<20140519143837.GA5228@infradead.org>
	<CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
	<20140526094240.B5508E009B@blue.fi.intel.com>
	<CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
	<53834310.8060808@redhat.com>
Date: Mon, 26 May 2014 08:38:19 -0500
Message-ID: <CAAih0NhTXOb+Hj+u+0QLrADxyOYc-EwHDCx5+1Fq7wiJsaY=_Q@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Jeff Smith <jsmith.lkml@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I misinterpreted "the overlapped part of the mapping(s) will be
discarded" as discarding the -new- mappings. My objections about
needing a replacement for remap_file_pages() are gone, but my concerns
about existing code still remain.
--Jeff

On Mon, May 26, 2014 at 8:35 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 26/05/2014 15:24, Jeff Smith ha scritto:
>
>> Your addr2 mmap() call is a bit incorrect semantically and
>> syntactically (you skipped the length arg). The addr2 request will
>> fail because mmap() does not implicitly munmap() occupied virtual
>> address space.
>
>
> With MAP_FIXED it does.  It is in the man page.
>
> Paolo
>
>
>> Even if you did that, the following still has a race
>> condition between the addr2 request and another thread grabbing the
>> same virtual space, which nothing short of a lock on all threads'
>> mmap()-ing logic can protect:
>
>
