Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbbAJV1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:27:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53095 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbAJV1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:27:00 -0500
Date: Sat, 10 Jan 2015 22:26:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150110212657.GE12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
 <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic>
 <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
 <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
 <CA+55aFzhgnHipD_mAA6qp9bum2b_j_7_3uWN4MHtwh6y20krcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzhgnHipD_mAA6qp9bum2b_j_7_3uWN4MHtwh6y20krcg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 01:08:33PM -0800, Linus Torvalds wrote:
> It was true for some AMD CPU's in particular. One insn/cycle vs two.

Probably on K8: Agner Fog's insn tables show reciprocal throughput of
1/2 for MOV r64/m64 vs 1 for PUSH/POP.

> I personally would be very happy to go back to push/pop sequences.
> Even without a fancy stack engine like Intel has done for a while,
> even *simple* cores can generally pair pushes and pops. I think the

I think all the modern x86 machines have stack engines now :-)

> original Pentium already had a special magic pairing logic to pair
> pushes and pops despite both instructions using %esp. It's a common
> and fairly trivial special case, and the fact that a few AMD
> microarchitectures didn't do it is likely not really a good reason to
> avoid repeated push/pop instructions.

Well, according to the optimization manual, on F15h (Bulldozer and
later) PUSH/POP are faster than MOVs and on F16h (Jaguar and later) both
MOV and PUSH/POP have latency of 1, with MOV having a 1/2 throughput vs
PUSH/POP throughput of 1. So theoretically we can do 2 MOVs per cycle
there vs 1 PUSH/POP.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
