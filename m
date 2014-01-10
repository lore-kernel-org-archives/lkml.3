Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbaAJUMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:12:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40423 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaAJUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:12:45 -0500
Date: Fri, 10 Jan 2014 21:12:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
Message-ID: <20140110201234.GL7572@laptop.programming.kicks-ass.net>
References: <52D011C9.7000209@hp.com>
 <20140110165822.GI7572@laptop.programming.kicks-ass.net>
 <20140110170223.GD8224@laptop.programming.kicks-ass.net>
 <20140110174141.GE8224@laptop.programming.kicks-ass.net>
 <CALCETrW2r=_Vt7+4aNKkKGeCAi8=WPULvPX3eyUEKH5nsu_CKQ@mail.gmail.com>
 <52D04D6D.9010504@hp.com>
 <CALCETrXG5k8Pk8ctYPJ_uKhVbyQ9=vVEgLeXb3Zvw+V+JSDMFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXG5k8Pk8ctYPJ_uKhVbyQ9=vVEgLeXb3Zvw+V+JSDMFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 11:56:07AM -0800, Andy Lutomirski wrote:
>  - The perf callchain code tries to read from a bad userspace pointer
> (not sure why -- the ip value in the vsyscall page *is* readable).
> That traps (as expected), but the trap handler injects SIGSEGV due to
> sig_on_uaccess_fault==1.

So the perf thing tries to walk the entire stack in order to obtain a
callchain. Its fairly common to hit crap when attempting this :-)
