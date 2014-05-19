Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaESOfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:35:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:19596 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbaESOfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,867,1392192000"; 
   d="scan'208";a="541484182"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Kenny Simpson <theonetruekenny@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
In-Reply-To: <20140519130114.GA3140@dhcp22.suse.cz>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140519143540.BE9F6E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 17:35:40 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko wrote:
> [CCing Kirill and other people involved]
> 
> On Sun 18-05-14 00:03:28, Kenny Simpson wrote:
> > I saw that remap_file_pages() was possibly going away to be replaced
> > by some emulation. I've used this call in several projects over the
> > years mostly as a way of mapping multiple virtual memory pages to
> > alias the same private or shared memory region (to do things like
> > circular buffers). mmap()
> > in the case of anonymous memory doesn't work as well since there is
> > not a file descriptor to reference.
> > 
> > Would this sort of thing be supported in the emulation, or should I be
> > planning on reimplementing/rewriting some things?

>From functional POV, emulation *should* be identical to original
remap_file_pages(), but slower. It would be nice, if you test it early.

It's not clear yet how long emulation will be there.
Is there a reason why you can't use fd from shared memory (shm_open() or
direct open() on /dev/shm/xxx)?

-- 
 Kirill A. Shutemov
