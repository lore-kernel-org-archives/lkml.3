Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3J1Rs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:48:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38952 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848Ab3J1Rs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:48:26 -0400
X-Sasl-enc: gXiCg77vakj439Jk6nw2gEhDrKNFxVPyp5YsDCCQOGnc 1382982505
Message-ID: <526EA366.4020204@iki.fi>
Date: Mon, 28 Oct 2013 19:48:22 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi> <20131028141152.GA1040@linux.vnet.ibm.com> <526E72EC.9060400@iki.fi> <20131028173152.GB1040@linux.vnet.ibm.com>
In-Reply-To: <20131028173152.GB1040@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 7:31 PM, Srikar Dronamraju wrote:
>>> But what if a system has both 32 bit libc and 64 bit libc?
>>> Wont we could end up with 2 libc:setjmp?
>>> Should we give some more intelligence into perf to choose the 64 bit
>>> libc over 32 bit one?
>> You can just trace both of them by default, no?
>>
> There has to be a one to one association with the event name and its
> mapping.  Every event name will finally map to a unique inode and an
> offset.
>
> One option would be for perf to look at these markers and have a
> different event name for similar markers in different executables.

I think we are talking past each other here.

Yes, I understand that you need an fully qualified name
for a SDT marker but there's absolutely no reason to force
feed that to the user of 'perf trace'.

For the 32-bit and 64-bit libc case, why cannot 'perf list'
by default print out something like:

$ perf list

   libc:setjmp [SDT marker group]

and provide a '--fully-qualified' command line option that:

$ perf list --fully-qualified

libc:setjmp => libc32:setjmp, libc64:setjmp      [SDT marker group]
libc32:setjmp => libc:setjmp@/lib/libc.so.6      [SDT marker]
libc64:setjmp => libc:setjmp@/lib64/libc.so.6  [SDT marker]

and then teach 'perf trace' to deal with SDT marker groups
where you trace two events, not one?

And again, there's no reason to treat system libraries like
libc the same way as some random binary in $HOME. You
can use the fully qualified name in 'perf list' for things
that are not in /lib or some perf-specific whitelist.

                     Pekka
