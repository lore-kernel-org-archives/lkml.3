Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3LEQcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:32:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740Ab3LEQcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:32:03 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 05 Dec 2013 11:31:18 -0500
In-Reply-To: <87fvq9cwlk.fsf@tassilo.jf.intel.com> (Andi Kleen's message of "Tue, 03 Dec 2013 16:01:59 -0800")
Message-ID: <y0my53zqmy1.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> [...]  While it sounds interesting, I would strongly advise to make
> this capability only available to root. Traditionally lots of
> complex byte code languages which were designed to be "safe" and
> verifiable weren't really. e.g. i managed to crash things with
> "safe" systemtap multiple times. [...]

Note that systemtap has never been a byte code language, that avenue
being considered lkml-futile at the time, but instead pure C.  Its
safety comes from a mix of compiled-in checks (which you can inspect
via "stap -p3") and script-to-C translation checks (which are
self-explanatory).  Its risks come from bugs in the checks (quite
rare), problems in the runtime library (rare), and problems in
underlying kernel facilities (rare or frequent - consider kprobes).


> So the likelyhood of this having some hole somewhere (either in
> the byte code or in some library function) is high.

Very true!


- FChE
