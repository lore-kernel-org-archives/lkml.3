Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaEZNfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:35:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64998 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaEZNfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:35:21 -0400
Message-ID: <53834310.8060808@redhat.com>
Date: Mon, 26 May 2014 15:35:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jeff Smith <jsmith.lkml@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: remap_file_pages() use
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>	<20140519130114.GA3140@dhcp22.suse.cz>	<20140519143540.BE9F6E009B@blue.fi.intel.com>	<20140519143837.GA5228@infradead.org>	<CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>	<20140526094240.B5508E009B@blue.fi.intel.com> <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
In-Reply-To: <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/05/2014 15:24, Jeff Smith ha scritto:
> Your addr2 mmap() call is a bit incorrect semantically and
> syntactically (you skipped the length arg). The addr2 request will
> fail because mmap() does not implicitly munmap() occupied virtual
> address space.

With MAP_FIXED it does.  It is in the man page.

Paolo

> Even if you did that, the following still has a race
> condition between the addr2 request and another thread grabbing the
> same virtual space, which nothing short of a lock on all threads'
> mmap()-ing logic can protect:

