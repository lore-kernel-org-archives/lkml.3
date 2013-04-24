Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3DXJwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:52:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52374 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3DXJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:52:23 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-3f-5177ab55baaf
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366732681.9609.157.camel@gandalf.local.home>
	<CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
	<20130424065018.GC27551@gmail.com>
Date: Wed, 24 Apr 2013 18:52:21 +0900
In-Reply-To: <20130424065018.GC27551@gmail.com> (Ingo Molnar's message of
	"Wed, 24 Apr 2013 08:50:18 +0200")
Message-ID: <87a9oob6i2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, 24 Apr 2013 08:50:18 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
>
>> Hello,
>> 
>> On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
>> >> This patchset implements a front-end tool for kernel's ftrace.  It
>> >> uses function_graph tracer by default and normal function tracer is
>> >> also supported.  (Of course you need to enable those tracers in your
>> >> kernel first.)
>> 
>> On Tue, Apr 23, 2013 at 6:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > Very nice Namhyung, thanks for doing this. I did a quick run through of
>> > the patches and I have no complaints about them. I'm not sure how the
>> > others will feel about it.
>> 
>> I also skimmed through the patches and they look like a reasonable
>> starting point. So FWIW,
>> 
>> Acked-by: Pekka Enberg <penberg@kernel.org>
>> 
>> Are there any plans in trying to consolidate 'perf trace' and this? As
>> a user I don't really care what the underlying mechanism and would
>> like things to just work out of the box.
>
> Exactly. I'd love to see ftrace and perf trace unified.
>
> I have no objections against having a 'perf ftrace' interim step - as long 
> as it's really a temporary migration construct, not something we intend to 
> keep forever.

Hmm.. okay.

I think it'd be great if perf trace can cover both of kernel and user
spaces.  But function tracing in userspace looks impossible IMHO.

So how about changing perf trace to receive proposed sub-commands
(live/record/show/report) and following options:

  --kernel::	do ftrace (for kernel functions)
  --syscall::	do system call tracing (what perf trace does now)


But I think we need to have an agreement on the file/directory format to
support multiple recorder threads first.  Any comments on this issue?

Thanks,
Namhyung
