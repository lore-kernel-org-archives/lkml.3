Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaGCJOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:14:48 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33319 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750908AbaGCJOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:14:45 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexei Starovoitov'" <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Arnaldo Carvalho de Melo" <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "Linux API" <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
Thread-Topic: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
Thread-Index: AQHPlknrjjkyXHF39E2brFC82m+gmpuOD4YA
Date: Thu, 3 Jul 2014 09:13:33 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726BF1A@AcuExch.aculab.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<CA+ZOOTODDPN=6SECq1uPPD7AGP1zgBJ+bfYaX9o3YhnaCTiHYQ@mail.gmail.com>
 <CAMEtUuxfrAUDDQVGNsNV2PeDii-6LAwQCbB2XGEHTJDwkkvyWg@mail.gmail.com>
In-Reply-To: <CAMEtUuxfrAUDDQVGNsNV2PeDii-6LAwQCbB2XGEHTJDwkkvyWg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s639ErSk006034

From: Alexei Starovoitov
> >> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
> > +1 to removing the _ macro. If you want to avoid the 3 lines (is there
> > anything in the style guide against "if ((err=OP) < 0) ..." ?), at
> 
> assignment and function call inside 'if' ? I don't like such style.
> 
> > least use some meaningful macro name (DO_AND_CHECK, or something like
> > that).

It would have to be RETURN_IF_NEGATIVE().
But even then it is skipped by searches for 'return'.

> Try replacing _ with any other name and see how bad it will look.
> I tried with MACRO_NAME and with 'if (err) goto' and with 'if (err) return',
> before I converged on _ macro.
> I think it's a hidden gem of this patch.

No, it is one of those things that 'seems like a good idea at the time',
but causes grief much later on.

Have you considered saving the error code into 'env' and making most of
the functions return if an error is set?
Then the calling code need not check the result of every function call.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
