Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaFXIeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaFXIeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:34:07 -0400
Message-ID: <53A937CB.7040309@redhat.com>
Date: Tue, 24 Jun 2014 10:33:15 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Chema Gonzalez <chema@google.com>, "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] split BPF out of core networking
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com> <538C3C94.3080206@redhat.com> <CAMEtUuzkjZCsReWH9cZs8AU0mJjZH9YOdCBTWusxe6-NZ9mQ=g@mail.gmail.com> <538CAEA6.4060307@redhat.com> <CAMEtUuwxJOgYgFjg9deQZOffeg6-JUGZXZ1Rj344eQmriQ0F0Q@mail.gmail.com> <538D8DAA.7090105@redhat.com> <CAMEtUuw8uyCGeLeUB0PXm5cCpqcsjPLZt6y9FcKjapbVPjWTuw@mail.gmail.com> <538E319B.3000606@redhat.com> <CAMEtUuzsHJioXZtuGje6UmwZmcmDZEn8PdkkYanA9j1sp242+Q@mail.gmail.com> <CA+ZOOTOfq705CbUjx9ppw4gLxJ8JFCaFsphwhAS+NskHVjd86Q@mail.gmail.com> <CAMEtUuxU_FKL4TJ2wJtOngean2RjjJxBbYpxNjJQKjA7HtU2Bg@mail.gmail.com> <CA+ZOOTOjRmj-C0tncH=j4ZJj8aMMVF1RLK-gQiSB6RG=G5Xo7w@mail.gmail.com> <CAMEtUuwV3y4G5+kLQNXojn4vrLmub4JVf1RyZoRoNNnX8U_yJA@mail.gmail.com>
In-Reply-To: <CAMEtUuwV3y4G5+kLQNXojn4vrLmub4JVf1RyZoRoNNnX8U_yJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 11:57 PM, Alexei Starovoitov wrote:
> On Fri, Jun 20, 2014 at 9:44 AM, Chema Gonzalez <chema@google.com> wrote:
...
>>>>    - nop: I'd like to have a nop. Do I know why? Nope.
>>> nope. Let's not add unnecessary instructions.
>> A valid nop is a useful instruction: padding, filling up arrays of
>> sock_filter_int correctly (as in lib/test_bpf.c, where we're currently
>> using a "ld #0", which loads zero to register A), and other use cases
>> (see http://en.wikipedia.org/wiki/NOP ).
>
> especially I don't like to add 'nop' instruction.
> code==0 to mean 'ld #0' is one of classic BPF ugliness.

I think it was probably unintended to be able to have unreachable
code e.g. filled with 'nops' where both jt, jf just jump over it,
but that quirk we cannot change anymore in the classic checker
and have to carry onwards.

> We're not filling up arrays with nops in lib/test_bpf.c
> Zero is invalid opcode in eBPF and should stay so, since it's
> an easy check for humans like me who are looking at eBPF in hex.
