Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaLDXMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:12:16 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:38779 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260AbaLDXMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:12:12 -0500
MIME-Version: 1.0
In-Reply-To: <1417734048.2721.22.camel@perches.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
	<1417734048.2721.22.camel@perches.com>
Date: Thu, 4 Dec 2014 15:12:11 -0800
Message-ID: <CAADnVQKJHXbhJFtibj34ZQ2HLbYUFURt0S3Ho4bX7LFf_GsPQw@mail.gmail.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: Reduce is_ereg() code size
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Joe Perches <joe@perches.com>, Daniel Borkmann <dborkman@redhat.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 3:00 PM, Joe Perches <joe@perches.com> wrote:
> Use the (1 << reg) & mask trick to reduce code size.
>
> x86-64 size difference -O2 without profiling for various
> gcc versions:
>
> $ size arch/x86/net/bpf_jit_comp.o*
>    text    data     bss     dec     hex filename
>    9266       4       0    9270    2436 arch/x86/net/bpf_jit_comp.o.4.4.new
>   10042       4       0   10046    273e arch/x86/net/bpf_jit_comp.o.4.4.old
>    9109       4       0    9113    2399 arch/x86/net/bpf_jit_comp.o.4.6.new
>    9717       4       0    9721    25f9 arch/x86/net/bpf_jit_comp.o.4.6.old
>    8789       4       0    8793    2259 arch/x86/net/bpf_jit_comp.o.4.7.new
>   10245       4       0   10249    2809 arch/x86/net/bpf_jit_comp.o.4.7.old
>    9671       4       0    9675    25cb arch/x86/net/bpf_jit_comp.o.4.9.new
>   10679       4       0   10683    29bb arch/x86/net/bpf_jit_comp.o.4.9.old
>
> Signed-off-by: Joe Perches <joe@perches.com>

probably it was worth noting in comment that
reg is 4-bit value and AUX_REG==12, so it won't overflow.

Dave, it's for net-next of course.

Suggested-by: Alexei Starovoitov <ast@plumgrid.com>
Tested-by: Alexei Starovoitov <ast@plumgrid.com>
