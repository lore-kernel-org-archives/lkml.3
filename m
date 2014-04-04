Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaDEF5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 01:57:00 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38302 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaDEF46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 01:56:58 -0400
Message-ID: <533E571C.4080902@gmail.com>
Date: Fri, 04 Apr 2014 08:54:20 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: mtk.manpages@gmail.com, Richard Hansen <rhansen@bbn.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org> <1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com> <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com> <533D4B42.4040600@codeaurora.org>
In-Reply-To: <533D4B42.4040600@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 01:51 PM, Christopher Covington wrote:
> On 04/03/2014 04:25 AM, Michael Kerrisk (man-pages) wrote:
> 
>> I think the only reasonable solution is to better document existing
>> behavior and what the programmer should do. With that in mind, I've
>> drafted the following text for the msync(2) man page:
>>
>>     NOTES
>>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must  be
>>        specified  in  flags.   However,  Linux permits a call to msync()
>>        that specifies neither of these flags, with  semantics  that  are
>>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Linux
>>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  properly
>>        tracks  dirty  pages  and  flushes them to storage as necessary.)
>>        Notwithstanding the Linux behavior, portable, future-proof appli‐
>>        cations  should  ensure  that they specify exactly one of MS_SYNC
>>        and MS_ASYNC in flags.
> 
> Nit: MS_SYNC or MS_ASYNC

Thanks. Reworded.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
