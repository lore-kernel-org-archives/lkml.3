Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaEOQB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:01:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaEOQB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:01:58 -0400
Date: Thu, 15 May 2014 18:01:53 +0200
From: chrubis@suse.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515160152.GA7529@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
 <5374C54B.7040408@gmail.com>
 <20140515154246.GC6926@rei.Home>
 <5374E2A4.2070408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374E2A4.2070408@zytor.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Have a look at this commit that tries to deal with passing 64 bit
> > numbers to syscalls. On 32 bit ABI (but not on X32) these needs to be
> > split up (accordingly to machine endianity).
> > 
> > https://github.com/linux-test-project/ltp/commit/04afb02b4280a20c262054e8f99a3fad4ad54916
> > 
> 
> That is wrong, too.  That assumes that there will never be padding
> words, which isn't true in the general case, either.

Well, it's still far better than the mess we had previously and it works
in most of the cases. However I would love to fix these correctly once
for all.

> I really believe the proper fix is to use assembly syscall stubs.  In
> klibc I build a fairly elaborate machinery to autogenerate such syscall
> stubs for a variety of architectures.

Then it would be nice to share these between klibc and LTP (and possible
everybody else).

-- 
Cyril Hrubis
chrubis@suse.cz
