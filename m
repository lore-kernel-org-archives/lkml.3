Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaGBIMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:12:30 -0400
Received: from mx0.aculab.com ([213.249.233.131]:37758 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751111AbaGBIM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:12:28 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexei Starovoitov'" <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
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
Thread-Index: AQHPlWebjjkyXHF39E2brFC82m+gmpuMbZvw
Date: Wed, 2 Jul 2014 08:11:20 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726B207@AcuExch.aculab.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<53B26BB0.90209@redhat.com>
 <CAMEtUuyc3+jrxG4r4=fk=Gc9OMhO8a2X1oyWPx1LsKzewVf01w@mail.gmail.com>
In-Reply-To: <CAMEtUuyc3+jrxG4r4=fk=Gc9OMhO8a2X1oyWPx1LsKzewVf01w@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s628CaN0028710

From: Alexei Starovoitov
...
> >> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
...
> >> +       _(get_map_info(env, map_id, &map));
> >
> > Nit: such macros should be removed, please.
> 
> It may surely look unconventional, but alternative is to replace
> every usage of _ macro with:
> err =
> if (err)
>   return err;
> 
> and since this macro is used 38 times, it will add ~120 unnecessary
> lines that will only make code much harder to follow.
> I tried not using macro and results were not pleasing.

The problem is that they are hidden control flow.
As such they make flow analysis harder for the casual reader.

The extra lines really shouldn't matter.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
