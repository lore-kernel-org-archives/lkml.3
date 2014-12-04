Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaLDXOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:14:55 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:40906 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaLDXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:14:54 -0500
Message-ID: <1417734891.22424.2.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: Reduce is_ereg() code size
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 15:14:51 -0800
In-Reply-To: <1417734048.2721.22.camel@perches.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
	 <1417734048.2721.22.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 15:00 -0800, Joe Perches wrote:
> Use the (1 << reg) & mask trick to reduce code size.
> 
> x86-64 size difference -O2 without profiling for various
> gcc versions:

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> compiled, untested by me, but per Alexei Starovoitov this passes
> the test_bpf suite

Really, the root cause of this is the 'inline' abuse in non fast paths
for non trivial functions.


