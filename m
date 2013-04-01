Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3DARAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:00:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11092 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab3DARAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:00:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18P7BG7nkWV6F0+JK2iGm8m
Date: Mon, 1 Apr 2013 09:59:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        juha.yrjola@solidboot.com, linux@arm.linux.org.uk, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130401165949.GI10155@atomide.com>
References: <2059303614.30062.1364731542427.JavaMail.apache@mail83.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2059303614.30062.1364731542427.JavaMail.apache@mail83.abv.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ивайло Димитров <freemangordon@abv.bg> [130331 05:10]:
>  
> Hi Pali,
> 
> Yep, the code looks almost identical, I guess with some tweaks all SMC code from that patch could be removed and instead used the one from SMC PPA API. 
> 
> What I don't get, is why one needs to disable/enable fiqs/irqs:
> 
> +static int call_sec_rom(u32 appl_id, u32 proc_id, u32 flag, ...)
> +{
> +	va_list ap;
> +	u32 ret;
> +	u32 val;
> +
> +	va_start(ap, flag);
> +	val = *(u32 *) &ap;
> +	local_irq_disable();
> +	local_fiq_disable();
> +	ret = omap3_rom_rng_call(appl_id, proc_id, flag,
> +				 (u32) virt_to_phys((void *) val));
> +	local_fiq_enable();
> +	local_irq_enable();
> +	va_end(ap);
> +
> +	return ret;
> +}
> 
> Do you have any idea why is that needed? Any other code I've ever seen to call SM, does not disable fiqs/irqs, is RNG SMC somehow special? I know this is Nokia's code, but still, if we can get some understanding...

Sounds like the fiq handling can be dropped based on what
the TI guys posted recently about FIQs only be available in
the secure mode starting with omap2.

Regards,

Tony
