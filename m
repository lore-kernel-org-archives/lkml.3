Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3FRKId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:08:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64280 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab3FRKIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:08:32 -0400
Date: Tue, 18 Jun 2013 11:07:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>
Subject: Re: [PATCH v6] arm: Preserve the user r/w register TPIDRURW on
 context, switch and fork
Message-ID: <20130618100715.GA3539@mudshark.cambridge.arm.com>
References: <51BF8A1C.5070403@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51BF8A1C.5070403@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:13:48PM +0100, André Hentschel wrote:
> From: André Hentschel <nerv@dawncrow.de>
> 
> Since commit 6a1c53124aa1 the user writeable TLS register was zeroed to
> prevent it from being used as a covert channel between two tasks.
> 
> There are more and more applications coming to Windows RT,
> Wine could support them, but mostly they expect to have
> the thread environment block (TEB) in TPIDRURW.
> 
> This patch preserves that register per thread instead of clearing it.
> Unlike the TPIDRURO, which is already switched, the TPIDRURW
> can be updated from userspace so needs careful treatment in the case that we
> modify TPIDRURW and call fork(). To avoid this we must always read
> TPIDRURW in copy_thread.
> 
> Signed-off-by: André Hentschel <nerv@dawncrow.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com> 
> 
> ---
> This patch is against Linux 3.10-rc6 (7d132055814ef17a6c7b69f342244c410a5e000f)
> 
> v2: rework and fixup of v1, based on a suggested patch by Will Deacon
> v3: total rework and fixup of v2
> v4: removed condition on assembler instruction,
>     adapted my code to kernel-style, both based on comments by Will Deacon
> v5: rebased v4 on 3.10-rc2 and adding this version history
> v6: moved loading the TLS registers to the macros
>     (fixing the "LDRD is not supported on all the CPUs we have" problem)

You've changed quite a lot with this version, including the way the macro
parameters are passed. Why not just replace the problematic ldrd with two
ldr instructions and be done with it? I don't think the simple build error
warrants an overhaul of the code we already had.

Cheers,

Will
