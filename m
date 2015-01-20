Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbbATLKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:10:02 -0500
Received: from smtp-out6.electric.net ([192.162.217.185]:61323 "EHLO
	smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbATLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:10:00 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Christophe Leroy'" <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "scottwood@freescale.com" <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 07/11] powerpc/8xx: macro for handling CPU15 errata
Thread-Topic: [PATCH v2 07/11] powerpc/8xx: macro for handling CPU15 errata
Thread-Index: AQHQNJjRMWEAMW5jYkWhruJEX7vwspzI2I/g
Date: Tue, 20 Jan 2015 11:09:08 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CACEFD9@AcuExch.aculab.com>
References: <20150120095735.A55671A5E86@localhost.localdomain>
In-Reply-To: <20150120095735.A55671A5E86@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KBABat011113

>From Christophe Leroy
> Having a macro will help keep clear code.

It might remove an #if but it doesn't really help.
All it means is that anyone reading the code has to hunt for
the definition before proceeding.

Some comment about what (and why) the extra code is needed
might help.

...
> +
> +#ifdef CONFIG_8xx_CPU15
> +#define DO_8xx_CPU15(tmp, addr)	\
> +	addi	tmp, addr, PAGE_SIZE;	\
> +	tlbie	tmp;			\
> +	addi	tmp, addr, PAGE_SIZE;	\

You've even transcribed this incorrectly.

Clearly not tested :-)

	David

> +	tlbie	tmp
> +#else
> +#define DO_8xx_CPU15(tmp, addr)
> +#endif
> +
>  InstructionTLBMiss:
>  #ifdef CONFIG_8xx_CPU6
>  	mtspr	SPRN_DAR, r3
> @@ -304,12 +315,7 @@ InstructionTLBMiss:
>  	EXCEPTION_PROLOG_0
>  	mtspr	SPRN_SPRG_SCRATCH2, r10
>  	mfspr	r10, SPRN_SRR0	/* Get effective address of fault */
> -#ifdef CONFIG_8xx_CPU15
> -	addi	r11, r10, PAGE_SIZE
> -	tlbie	r11
> -	addi	r11, r10, -PAGE_SIZE
> -	tlbie	r11
> -#endif
> +	DO_8xx_CPU15(r11, r10)
> 
>  	/* If we are faulting a kernel address, we have to use the
>  	 * kernel page tables.
> --
> 2.1.0
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
