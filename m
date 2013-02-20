Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461Ab3BTCjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:39:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6740 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246Ab3BTCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:39:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="25870598"
Message-ID: <51243741.8070409@codeaurora.org>
Date: Tue, 19 Feb 2013 18:38:57 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] arm: use built-in byte swap function
References: <20130129181046.GC25415@pd.tnic> <1359541333.3529.186.camel@shinybook.infradead.org> <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com> <20130131092801.GV23505@n2100.arm.linux.org.uk> <20130131145947.f62474a0600848df86548b96@freescale.com> <20130201011712.GF23505@n2100.arm.linux.org.uk> <1359703995.23531.6.camel@shinybook.infradead.org> <20130205210436.670c62e26d2121330e87af35@freescale.com> <1360141322.6066.4.camel@shinybook.infradead.org> <20130206191905.ac8eb6743e69425f30888704@freescale.com> <20130207181315.GM17833@n2100.arm.linux.org.uk> <1360344301.6066.263.camel@shinybook.infradead.org> <alpine.LFD.2.02.1302081503430.6300@xanadu.home> <1360363233.6066.283.camel@shinybook.infradead.org> <alpine.LFD.2.02.1302081745500.6300@xanadu.home> <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com> <alpine.LFD.2.02.1302082102380.6300@xanadu.home> <20130219203115.114eab79e8d2099c6306d921@freescale.com>
In-Reply-To: <20130219203115.114eab79e8d2099c6306d921@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/2013 6:31 PM, Kim Phillips wrote:
> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index af72969..dbee639 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -45,3 +45,5 @@ lib-$(CONFIG_ARCH_SHARK)	+= io-shark.o
>  
>  $(obj)/csumpartialcopy.o:	$(obj)/csumpartialcopygeneric.S
>  $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
> +
> +CFLAGS_bswapsdi2.o = -O2

Please put a comment here so we don't have to dig through git history
and/or emails to understand why this has -O2 forced on for this file.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

