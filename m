Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab3EWXOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:14:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab3EWXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:14:51 -0400
Date: Fri, 24 May 2013 00:13:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v7] arm: use built-in byte swap function
Message-ID: <20130523231336.GS18614@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg> <20130220214943.9b28a5b208da9f081387c55e@freescale.com> <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg> <20130221005221.15279b1372501af12c1e4f32@freescale.com> <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg> <20130221203327.6558f89277468f7ffffa6506@freescale.com> <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg> <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com> <1361661654.18110.102.camel@shinybook.infradead.org> <20130523114654.1f273241725205c6703b2226@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523114654.1f273241725205c6703b2226@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:46:54AM -0500, Kim Phillips wrote:
> Enable the compiler intrinsic for byte swapping on arch ARM.  This
> allows the compiler to detect and be able to optimize out byte
> swappings, and has a very modest benefit on vmlinux size (Linaro gcc
> 4.8):
> 
>    text	   data	    bss	    dec	    hex	filename
> 2840310	 123932	  61960	3026202	 2e2d1a	vmlinux-lart #orig
> 2840152	 123932	  61960	3026044	 2e2c7c	vmlinux-lart #builtin-bswap
> 
> 6473120	 314840	5616016	12403976 bd4508	vmlinux-mxs #orig
> 6472586	 314848	5616016	12403450 bd42fa	vmlinux-mxs #builtin-bswap
> 
> 7419872	 318372	 379556	8117800	 7bde28	vmlinux-imx_v6_v7 #orig
> 7419170	 318364	 379556	8117090	 7bdb62	vmlinux-imx_v6_v7 #builtin-bswap
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> resending as v6 appears to have fallen though the cracks.  Russell?

Please put it in the patch system (otherwise I do drop patches.)
