Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaGUMZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaGUMZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:25:01 -0400
Message-ID: <53CD0692.5070700@redhat.com>
Date: Mon, 21 Jul 2014 14:24:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 2/3] x86: Test rflags.rf is set upon faults
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il> <1405942794-22681-3-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405942794-22681-3-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 13:39, Nadav Amit ha scritto:
> @@ -176,7 +176,7 @@ unsigned exception_vector(void)
>      unsigned short vector;
>  
>      asm("mov %%gs:4, %0" : "=rm"(vector));

"rm" is wrong here, it should be "r".  If we make it "q" instead, we can
use movb.


	unsigned char vector;

	asm("movb %%gs:4, %b0" : "=q"(vector));

> -    return vector;
> +    return (u8)vector;
>  }

> 
> +bool exception_rflags_rf(void)
> +{
> +    unsigned short rf_flag;
> +
> +    asm("mov %%gs:4, %0" : "=rm"(rf_flag));
> +    return (rf_flag >> 8) & 1;
> +}
> +

Same here, use "movb %%gs:5, %b0" and an unsigned char.

Paolo
