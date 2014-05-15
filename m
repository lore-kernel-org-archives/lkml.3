Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaEOPBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:01:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42077 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaEOPBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:01:11 -0400
Message-ID: <5374D662.8090002@zytor.com>
Date: Thu, 15 May 2014 07:59:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>
CC: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com>
In-Reply-To: <5374C54B.7040408@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 06:46 AM, Michael Kerrisk (man-pages) wrote:
> 
> People have a number of times noted that there are problems
> with syscall(), but I'm not knowledgeable on the details.
> I'd happily take a patch to the man page (which, for historical
> reasons, is actually syscall(2)) that explains the the problems 
> (and ideally notes those platforms where there are no problems).
> 

It has to do with how ABIs deal with doublewidth arguments.

There is a reason why Linux syscall ABIs generally have a 1:1 mapping
with the user space ABIs, and why the system call argument is passed not
in the first argument but in a different place (usually a separately
clobbered register, e.g. %eax on x86-64).

On some platforms, doublewidth registers have to be aligned in register
pairs.  On some other platforms, enough arguments mean some will be
passed in memory, where they are forced to be aligned, or they are not
allowed to straddle the register-memory boundary.  All of this means
that padding words might be introduced, and they will be introduced in
the wrong place because of the additional argument introduced at the
beginning of the argument sequence.

On the other hand, the old SYSCALL user-space macros just plain didn't
handle doubleword arguments.

	-hpa

