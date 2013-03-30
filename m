Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3C3WbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:31:22 -0400
Received: from smtp-out.abv.bg ([194.153.145.70]:34978 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab3C3WbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:31:21 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=jwDLR7e3bBo5Tv7cjNL/lhYjachy2Qg4IMXHfa/6gbmuThz/JnD1tmjGIXWTBmS2K
	w+HcG7zvbLQqhWmfflt7P0TE01gTzArJ78mz+STCnRCcF75BpQngshMp55JFMLDbXnf
	ff8YML06Dq9bWWzbdnRpS1nMsZFZOaj5Hl10zWc=
Date: Sun, 31 Mar 2013 00:31:18 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1838509461.25809.1364682678664.JavaMail.apache@mail83.abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

 >-------- Оригинално писмо --------
 >От:  Pavel Machek 
 >Относно: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
 >До: Pali Rohár 
 >Изпратено на: Събота, 2013, Март 30 20:36:54 EET
 >
 >
 >Hi!
 >
 >> +u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs, u32 arg1, u32 arg2,
 >> +			   u32 arg3, u32 arg4)
 >> +{
 >> +	u32 ret;
 >> +	u32 param[5];
 >> +
 >> +	param[0] = nargs+1;
 >> +	param[1] = arg1;
 >> +	param[2] = arg2;
 >> +	param[3] = arg3;
 >> +	param[4] = arg4;
 >> +
 >> +	/*
 >> +	 * Secure API needs physical address
 >> +	 * pointer for the parameters
 >> +	 */
 >> +	flush_cache_all();
 >> +	outer_clean_range(__pa(param), __pa(param + 5));
 >> +	ret = rx51_ppa_smc(idx, flag, __pa(param));
 >> +
 >> +	return ret;
 >> +}
 >
 >You can do without ret variable... Also more detailed changelog would
 >be nice... like what exact problem this works around.
 >

Sure i can, but I don't see a reason to ignore SM's return value. Changelog of what?
 >
 >
 >So... some CPU errata where code sharing virtual addresses could be
 >executed improperly?
 >								
 >> @@ -103,6 +104,12 @@ static void __init rx51_init(void)
 >>  	rx51_peripherals_init();
 >>  	rx51_camera_init();
 >>  
 >> +#ifdef CONFIG_ARM_ERRATA_430973
 >> +	printk(KERN_INFO &quot;Enabling ARM errata 430973 workaround.&#92;n&quot;);
 >> +	/* set IBE to 1 */
 >> +	rx51_secure_update_aux_cr(1 << 6, 0);
 >> +#endif
 >> +
 >
 >Thanks,
 >								Pavel
 >
 >-- 
 >(english) http://www.livejournal.com/~pavelmachek
 >(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
 >

I guess if you read the thread over the ML you'll have your questions already answered. 
Or google for "ARM errata 430973 workaround" :).

Regards,
Ivo
