Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3KEVuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:50:39 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:42756
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab3KEVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:50:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h8275bh8275dh1de097hz2dh2a8h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
Date: Tue, 5 Nov 2013 15:45:39 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Nicolas Pitre <nico@fluxnic.net>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v7] arm: use built-in byte swap function
Message-ID: <20131105154539.571de66098b77166db039a3b@freescale.com>
In-Reply-To: <alpine.LFD.2.03.1310262235310.1951@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
	<20130219203115.114eab79e8d2099c6306d921@freescale.com>
	<alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
	<1361356696.13482.269.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
	<1361367842.13482.279.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
	<1361372008.13482.280.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
	<20130220214943.9b28a5b208da9f081387c55e@freescale.com>
	<alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
	<20130221005221.15279b1372501af12c1e4f32@freescale.com>
	<alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
	<20130221203327.6558f89277468f7ffffa6506@freescale.com>
	<alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
	<20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
	<1361661654.18110.102.camel@shinybook.infradead.org>
	<20130523114654.1f273241725205c6703b2226@freescale.com>
	<alpine.LFD.2.03.1310262235310.1951@syhkavp.arg>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 22:41:34 -0400
Nicolas Pitre <nico@fluxnic.net> wrote:

> On Thu, 23 May 2013, Kim Phillips wrote:
> 
> > Enable the compiler intrinsic for byte swapping on arch ARM.  This
> > allows the compiler to detect and be able to optimize out byte
> > swappings, and has a very modest benefit on vmlinux size (Linaro gcc
> > 4.8):
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 2840310	 123932	  61960	3026202	 2e2d1a	vmlinux-lart #orig
> > 2840152	 123932	  61960	3026044	 2e2c7c	vmlinux-lart #builtin-bswap
> > 
> > 6473120	 314840	5616016	12403976 bd4508	vmlinux-mxs #orig
> > 6472586	 314848	5616016	12403450 bd42fa	vmlinux-mxs #builtin-bswap
> > 
> > 7419872	 318372	 379556	8117800	 7bde28	vmlinux-imx_v6_v7 #orig
> > 7419170	 318364	 379556	8117090	 7bdb62	vmlinux-imx_v6_v7 #builtin-bswap
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > Reviewed-by: Nicolas Pitre <nico@linaro.org>
> > Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> Did this ever go somewhere?
> 
> Russell suggested at the time to base it against a mainline kernel 
> (since it was patching files which apparently were already patched with 
> out-of-tree lz4 patches) and send it to his patch system.

I'll re-base and send it to his patch system.

Thanks,

Kim

