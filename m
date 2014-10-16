Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJPP5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:57:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40199 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaJPP5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:57:52 -0400
Date: Thu, 16 Oct 2014 17:57:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141016155756.GE30314@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <20141016084227.GI7369@worktop.fdxtended.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141016084227.GI7369@worktop.fdxtended.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:42:27AM +0200, Peter Zijlstra wrote:
> gawd I hate the static_key API.

Yahaa, I like to twist my brain for fun just by staring at
sched_clock_stable() logic.

Oh, and it needs fixing btw because if you look at the asm that comes
out, after the jump labels have run, you get an unconditional jump to
the likely code doing RDTSC.

This should be avoided and we should have the likely code be laid out
first with the NOP and have the jump labels patch in the unconditional
JMP only on the small amount of systems where we're unlikely to be using
the TSC... For that we'd need to pound on jump labels a bit more though.

-- 
Regards/Gruss,
    Boris.
--
