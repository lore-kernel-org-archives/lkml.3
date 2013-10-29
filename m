Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3J2DTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:19:42 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51717 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3J2DTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:19:41 -0400
Message-ID: <526F2949.5000208@hitachi.com>
Date: Tue, 29 Oct 2013 12:19:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi> <20131028141152.GA1040@linux.vnet.ibm.com> <526E72EC.9060400@iki.fi> <20131028173152.GB1040@linux.vnet.ibm.com> <526EA366.4020204@iki.fi>
In-Reply-To: <526EA366.4020204@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 2:48), Pekka Enberg wrote:
> On 10/28/13 7:31 PM, Srikar Dronamraju wrote:
>>>> But what if a system has both 32 bit libc and 64 bit libc?
>>>> Wont we could end up with 2 libc:setjmp?
>>>> Should we give some more intelligence into perf to choose the 64 bit
>>>> libc over 32 bit one?
>>> You can just trace both of them by default, no?
>>>
>> There has to be a one to one association with the event name and its
>> mapping.  Every event name will finally map to a unique inode and an
>> offset.
>>
>> One option would be for perf to look at these markers and have a
>> different event name for similar markers in different executables.
> 
> I think we are talking past each other here.
> 
> Yes, I understand that you need an fully qualified name
> for a SDT marker but there's absolutely no reason to force
> feed that to the user of 'perf trace'.
> 
> For the 32-bit and 64-bit libc case, why cannot 'perf list'
> by default print out something like:
> 
> $ perf list
> 
>    libc:setjmp [SDT marker group]
> 
> and provide a '--fully-qualified' command line option that:
> 
> $ perf list --fully-qualified
> 
> libc:setjmp => libc32:setjmp, libc64:setjmp      [SDT marker group]
> libc32:setjmp => libc:setjmp@/lib/libc.so.6      [SDT marker]
> libc64:setjmp => libc:setjmp@/lib64/libc.so.6  [SDT marker]
> 
> and then teach 'perf trace' to deal with SDT marker groups
> where you trace two events, not one?

Ah, that's a good idea. :)
And it also is needed for another probe event because
sometimes inlined functions have multiple instances.
I'd like to fold them as one event group.

Thank you!
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


