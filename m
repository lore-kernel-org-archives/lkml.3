Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaEOPxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:53:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbaEOPxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:53:18 -0400
Message-ID: <5374E2A4.2070408@zytor.com>
Date: Thu, 15 May 2014 08:52:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: chrubis@suse.cz, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com> <20140515154246.GC6926@rei.Home>
In-Reply-To: <20140515154246.GC6926@rei.Home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 08:42 AM, chrubis@suse.cz wrote:
> Hi!
>> People have a number of times noted that there are problems
>> with syscall(), but I'm not knowledgeable on the details.
>> I'd happily take a patch to the man page (which, for historical
>> reasons, is actually syscall(2)) that explains the the problems 
>> (and ideally notes those platforms where there are no problems).
> 
> Have a look at this commit that tries to deal with passing 64 bit
> numbers to syscalls. On 32 bit ABI (but not on X32) these needs to be
> split up (accordingly to machine endianity).
> 
> https://github.com/linux-test-project/ltp/commit/04afb02b4280a20c262054e8f99a3fad4ad54916
> 

That is wrong, too.  That assumes that there will never be padding
words, which isn't true in the general case, either.

I really believe the proper fix is to use assembly syscall stubs.  In
klibc I build a fairly elaborate machinery to autogenerate such syscall
stubs for a variety of architectures.

	-hpa

