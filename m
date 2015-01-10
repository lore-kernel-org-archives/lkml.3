Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbbAJVIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:08:35 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41794 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbAJVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:08:34 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
	<1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
	<20150109121950.GD13637@pd.tnic>
	<CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
	<20150110142336.GC12218@pd.tnic>
	<CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
	<CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
Date: Sat, 10 Jan 2015 13:08:33 -0800
X-Google-Sender-Auth: wAV9IcXd42lak_RAzjlT_xSmRA0
Message-ID: <CA+55aFzhgnHipD_mAA6qp9bum2b_j_7_3uWN4MHtwh6y20krcg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Borislav Petkov <bp@alien8.de>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 12:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I asked this once, and someone told me that push/pop has lower
> throughput.  I find this surprising.

It was true for some AMD CPU's in particular. One insn/cycle vs two.

I personally would be very happy to go back to push/pop sequences.
Even without a fancy stack engine like Intel has done for a while,
even *simple* cores can generally pair pushes and pops. I think the
original Pentium already had a special magic pairing logic to pair
pushes and pops despite both instructions using %esp. It's a common
and fairly trivial special case, and the fact that a few AMD
microarchitectures didn't do it is likely not really a good reason to
avoid repeated push/pop instructions.

                   Linus
