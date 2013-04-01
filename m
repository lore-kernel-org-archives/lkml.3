Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3DAUhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:37:16 -0400
Received: from smtp-out.abv.bg ([194.153.145.99]:40414 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab3DAUhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:37:13 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=Dg+eQl2tWKu1BALdrvHwawjmbnZPt5ImrlpesRJPYP4aDdcoVg5zJ1D9T27xk6ziZ
	qdmQMVUfGtIx3C5btTVLpI7m93AkTm1ArgLhZgMvaTj9DhLoSx4fVS7W5JBxELMFZIW
	YQ1wECcGYitb5XFTOQT223DuvuI3zst1HujvZyY=
Date: Mon, 1 Apr 2013 23:37:11 +0300 (EEST)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Tony Lindgren <tony@atomide.com>
Cc: pali.rohar@gmail.com, juha.yrjola@solidboot.com, linux@arm.linux.org.uk,
        mpm@selenic.com, herbert@gondor.hengli.com.au,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <414980284.76676.1364848631348.JavaMail.apache@mail82.abv.bg>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 It could be that I am misreading something, but RX51 is OMAP3.

Regards,
Ivo


 >-------- Оригинално писмо --------
 >От:  Tony Lindgren 
 >Относно: Re: [PATCH] OMAP3 ROM Random Number Generator support
 >До: Ивайло Димитров 
 >Изпратено на: Понеделник, 2013, Април 1 19:59:50 EEST
 >
 >
 >* Ивайло Димитров  [130331 05:10]:
 >>  
 >> Hi Pali,
 >> 
 >> Yep, the code looks almost identical, I guess with some tweaks all SMC code from that patch could be removed and instead used the one from SMC PPA API. 
 >> 
 >> What I don't get, is why one needs to disable/enable fiqs/irqs:
 >> 
 >> +static int call_sec_rom(u32 appl_id, u32 proc_id, u32 flag, ...)
 >> +{
 >> +	va_list ap;
 >> +	u32 ret;
 >> +	u32 val;
 >> +
 >> +	va_start(ap, flag);
 >> +	val = *(u32 *) &amp;ap;
 >> +	local_irq_disable();
 >> +	local_fiq_disable();
 >> +	ret = omap3_rom_rng_call(appl_id, proc_id, flag,
 >> +				 (u32) virt_to_phys((void *) val));
 >> +	local_fiq_enable();
 >> +	local_irq_enable();
 >> +	va_end(ap);
 >> +
 >> +	return ret;
 >> +}
 >> 
 >> Do you have any idea why is that needed? Any other code I've ever seen to call SM, does not disable fiqs/irqs, is RNG SMC somehow special? I know this is Nokia's code, but still, if we can get some understanding...
 >
 >Sounds like the fiq handling can be dropped based on what
 >the TI guys posted recently about FIQs only be available in
 >the secure mode starting with omap2.
 >
 >Regards,
 >
 >Tony
 >
