Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaGUJ0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:26:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbaGUJ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:26:12 -0400
Date: Mon, 21 Jul 2014 10:16:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Jiang Liu <liuj97@gmail.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/14] arm64: eBPF JIT compiler
Message-ID: <20140721091623.GA16122@arm.com>
References: <1405708100-13604-1-git-send-email-zlim.lnx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405708100-13604-1-git-send-email-zlim.lnx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 18, 2014 at 07:28:06PM +0100, Zi Shen Lim wrote:
> This series implements eBPF JIT compiler for arm64.
> Please see [14/14] for change log.
> 
> Patches [1-13/14] implement code generation functions.
> Patch [14/14] implements the actual eBPF JIT compiler.
> 
> Many thanks to everyone who's reviewed the code from
> RFCv1->RFCv3, especially Alexei for BPF bits, and Will
> for ARM64 codegen bits :)
> 
> BTW, I'm happy to maintain arch/arm64/net (i.e. arm64 BPF bits).
> Should I add a patch updating MAINTAINERS as Patch 15?

I don't think that's necessary at the moment, but if we start seeing an
influx of patches to arch/arm64/net, then that could make sense in the
future.

> This series requires a patch that exports a function
> from net/core (resulting from RFCv1 discussion). This patch
> has been merged into net-next @ 9f12fbe603f7
> ("net: filter: move load_pointer() into filter.h").
> 
> This series applies against net-next and is tested working
> with lib/test_bpf on ARMv8 Foundation Model.

Looks like it works on my Juno board too, so:

  Acked-by: Will Deacon <will.deacon@arm.com>

for the series.

It's a bit late for 3.17 now, so I guess we'll queue this for 3.18 (which
also means the dependency on -next isn't an issue). Perhaps you could repost
around -rc3?

Cheers,

Will
