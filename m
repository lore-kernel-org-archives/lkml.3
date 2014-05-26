Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaEZNwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:52:25 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49656 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaEZNwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140526134718.0AAC7E009B@blue.fi.intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<20140519143837.GA5228@infradead.org>
	<CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
	<20140526094240.B5508E009B@blue.fi.intel.com>
	<CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
	<53834310.8060808@redhat.com>
	<CAAih0NhTXOb+Hj+u+0QLrADxyOYc-EwHDCx5+1Fq7wiJsaY=_Q@mail.gmail.com>
	<20140526134718.0AAC7E009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 08:52:23 -0500
Message-ID: <CAAih0Nige+Cjoh6c=718P2R4BV5=RczuGh17voVgZEc_hyz16Q@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Jeff Smith <jsmith.lkml@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got no real issues at this point, but could you perhaps elaborate
a bit on the rough order of magnitude of "long" time and what cases
would be slower? I'm pretty sure that some places I've worked that
still have some remap_file_pages() logic in place aren't too religious
about checking dmesg.
--Jeff

On Mon, May 26, 2014 at 8:47 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Jeff Smith wrote:
>> OK, I misinterpreted "the overlapped part of the mapping(s) will be
>> discarded" as discarding the -new- mappings. My objections about
>> needing a replacement for remap_file_pages() are gone, but my concerns
>> about existing code still remain.
>
> As I said, emulation will be there for long time. With warning in dmesg.
> The emulation is interface-compatible, but slower in some cases (not
> your's).
>
> --
>  Kirill A. Shutemov
