Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbaESTOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:14:33 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:62722 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803AbaESTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140519151758.A2162E009B@blue.fi.intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<20140519143837.GA5228@infradead.org>
	<20140519150238.67898E009B@blue.fi.intel.com>
	<20140519151104.GA16736@infradead.org>
	<20140519151758.A2162E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 21:14:29 +0200
Message-ID: <CAFLxGvwhNE9rRn2k=HgT7UYWyQzAkfKdON=LCcXPvXbOJ80pFQ@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 5:17 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Christoph Hellwig wrote:
>> On Mon, May 19, 2014 at 06:02:38PM +0300, Kirill A. Shutemov wrote:
>> > > Stop right there.  We found out about two real life users of
>> > > remap_file_pages() already, without even committing the patches to warn
>> > > about using it to any tree.
>> >
>> > Who is the second here?     Oracle?
>>
>> PyPy.
>>
>> Oracle would be the third, although use of the feature is optional and
>> fairly hard to opt in to, so I didn't count it.
>
> IIUC PyPy uses the syscall in some early prototype and looks like guys are
> okay to rework it to mmap() if default sysctl_max_map_count will be high
> enough.

A quick search on github exposed three more users:
https://github.com/LotharSchwab/R-Framework
https://github.com/const86/glgrab
https://github.com/minimoog/virtualringbuffer

-- 
Thanks,
//richard
