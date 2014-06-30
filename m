Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaF3KH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:07:26 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52939 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752486AbaF3KHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:07:24 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexei Starovoitov'" <ast@plumgrid.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "Jiri Olsa" <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC net-next 07/14] bpf: expand BPF syscall with program
 load/unload
Thread-Topic: [PATCH RFC net-next 07/14] bpf: expand BPF syscall with
 program load/unload
Thread-Index: AQHPkmVz+cn4gNsbY0C9x2NiRLJlEpuFl6wAgABiq4CAA3RgQA==
Date: Mon, 30 Jun 2014 10:06:23 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17269505@AcuExch.aculab.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-8-git-send-email-ast@plumgrid.com>
	<CALCETrXDR1LVmbigTicBiddgvcucM1dGk1R7rxdJyBCvGEBQMw@mail.gmail.com>
 <CAMEtUuywNHVcZ__296NzXK7RPXUBOf7gNQY9JFx0a9PV0Se+wA@mail.gmail.com>
In-Reply-To: <CAMEtUuywNHVcZ__296NzXK7RPXUBOf7gNQY9JFx0a9PV0Se+wA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5UA7WGH010747

From: Alexei Starovoitov
> On Fri, Jun 27, 2014 at 5:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> >> eBPF programs are safe run-to-completion functions with load/unload
> >> methods from userspace similar to kernel modules.
> >>
> >> User space API:
> >>
> >> - load eBPF program
> >>   prog_id = bpf_prog_load(int prog_id, bpf_prog_type, struct nlattr *prog, int len)
> >>
> >>   where 'prog' is a sequence of sections (currently TEXT and LICENSE)
> >>   TEXT - array of eBPF instructions
> >>   LICENSE - GPL compatible
> >> +
> >> +       err = -EINVAL;
> >> +       /* look for mandatory license string */
> >> +       if (!tb[BPF_PROG_LICENSE])
> >> +               goto free_attr;
> >> +
> >> +       /* eBPF programs must be GPL compatible */
> >> +       if (!license_is_gpl_compatible(nla_data(tb[BPF_PROG_LICENSE])))
> >> +               goto free_attr;
> >
> > Seriously?  My mind boggles.
> 
> Yes. Quite a bit of logic can fit into one eBPF program. I don't think it's wise
> to leave this door open for abuse. This check makes it clear that if you
> write a program in C, the source code must be available.

That seems utterly extreme.
Loadable kernel modules don't have to be GPL.

I can imagine that some people might not want to load code for which
they don't have the source - but in that case they probably want to
compile it themselves anyway.

I don't want to have to put a gpl licence on random pieces of test
code I might happen to write for my own use.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
