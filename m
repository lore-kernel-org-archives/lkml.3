Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaLIT5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:57:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38122 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaLIT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:57:17 -0500
Date: Tue, 09 Dec 2014 14:57:12 -0500 (EST)
Message-Id: <20141209.145712.712673313891632719.davem@davemloft.net>
To: joe@perches.com
Cc: alexei.starovoitov@gmail.com, lambert.quentin@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: bpf_jit_comp: Reduce is_ereg() code size
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417734048.2721.22.camel@perches.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
	<1417734048.2721.22.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 11:57:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 04 Dec 2014 15:00:48 -0800

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

Applied.
