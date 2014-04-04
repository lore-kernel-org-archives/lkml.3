Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaDDHLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:11:32 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:40948 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaDDHL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:11:27 -0400
Message-ID: <533E5B17.8010804@gmail.com>
Date: Fri, 04 Apr 2014 09:11:19 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Troxel <gdt@ir.bbn.com>
CC: mtk.manpages@gmail.com, Richard Hansen <rhansen@bbn.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org>	<1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com>	<CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com> <rmivbuqy3hr.fsf@fnord.ir.bbn.com>
In-Reply-To: <rmivbuqy3hr.fsf@fnord.ir.bbn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 04/03/2014 02:57 PM, Greg Troxel wrote:
> 
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
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
>>
>> Comments on this draft welcome.
> 
> I think it's a step backwards to document unspecified behavior.  If
> anything, the man page should make it clear that providing neither flag
> results in undefined behavior and will lead to failure on systems on
> than Linux.  While I can see the point of not changing the previous
> behavior to protect buggy code, there's no need to document it in the
> man page and further enshrine it.

The Linux behavior is what it is. For the reasons I mentioned already,
it's unlikely to change. And, when the man pages omit to explain what
Linux actually does, there will one day come a request to actually
document the behavior. So, I don't think it's quite enough to say the 
behavior is undefined. On the other hand, it does not hurt to further
expand the portability warning. I made the text now:

    NOTES
       According to POSIX, either MS_SYNC or MS_ASYNC must be  specified
       in  flags, and  indeed failure to include one of these flags will
       cause msync() to fail on some systems.  However, Linux permits  a
       call  to  msync()  that  specifies  neither  of these flags, with
       semantics that are (currently) equivalent to specifying MS_ASYNC.
       (Since  Linux 2.6.19, MS_ASYNC is in fact a no-op, since the ker‐
       nel properly tracks dirty pages and flushes them  to  storage  as
       necessary.)    Notwithstanding   the  Linux  behavior,  portable,
       future-proof applications should ensure that they specify  either
       MS_SYNC or MS_ASYNC in flags.




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
