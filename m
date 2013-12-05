Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3LEWhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:37:09 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LEWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:37:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131205084657.09b6a2ce@gandalf.local.home>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131205104113.GB20283@gmail.com>
	<20131205084657.09b6a2ce@gandalf.local.home>
Date: Thu, 5 Dec 2013 14:36:58 -0800
Message-ID: <CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 5:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I know that it would be great to have the bpf filter run before
> recording of the tracepoint, but as that becomes quite awkward for a
> user interface, because it requires intimate knowledge of the kernel
> source, this speed up on the filter itself may be worth while to have
> it happen after the recording of the buffer. When it happens after the
> record, then the bpf has direct access to the event entry and its
> fields as described by the trace event format files.

I don't understand that 'awkward' part yet. What do you mean by 'knowledge of
the kernel'? By accessing pt_regs structure? Something else ?
Can we try fixing the interface first before compromising on performance?
