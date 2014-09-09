Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaIIKPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:15:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbaIIKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:15:23 -0400
Date: Tue, 9 Sep 2014 11:15:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Charlebois <charlebm@gmail.com>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "cl@linux.com" <cl@linux.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "jays.lee@samsung.com" <jays.lee@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@kernel.org" <acme@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Matthew Leach <Matthew.Leach@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "paulus@samba.org" <paulus@samba.org>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with
 clang
Message-ID: <20140909101515.GB1754@arm.com>
References: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
 <20140908105307.GF26030@arm.com>
 <CAFzeTN2Q-RkOeDx4jG5jiEtiN7i+gkfmyvBC1b3B1wpDPUDdxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFzeTN2Q-RkOeDx4jG5jiEtiN7i+gkfmyvBC1b3B1wpDPUDdxw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:35:47PM +0100, Mark Charlebois wrote:
> When I compile
> 
> int main()
> {
>         u64 foo, tmp;
> 
>        // This fails for clang but not gcc
>         asm volatile(
>         "       mrs     %0, mair_el1\n"
>         "       bfi     %0, %1, #%2, #8\n"
>         "       msr     mair_el1, %0\n"
>         "       isb\n"
>         : "=&r" (tmp)
>         : "r" (foo), "i" (MT_NORMAL * 8));
> }
> 
> Clang fails and GCC generates:
> 
> 00000000004004f0 <main>:
>   4004f0: d538a208 mrs x8, mair_el1
>   4004f4: b3601d08 bfi x8, x8, #32, #8
>   4004f8: d518a208 msr mair_el1, x8
>   4004fc: d5033fdf isb
>   400500: 2a1f03e0 mov w0, wzr
>   400504: d65f03c0 ret

Ok, so we can just drop the '#' prefix as it probably shouldn't be there
anyway. Can you send a patch making just that change, please?

Will
