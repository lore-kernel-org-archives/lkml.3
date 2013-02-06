Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab3BFXBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:01:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3BFXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:01:26 -0500
Message-ID: <5112E0C3.1080706@dawncrow.de>
Date: Thu, 07 Feb 2013 00:01:23 +0100
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arch@vger.kernel.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
References: <5112DC7E.4020108@dawncrow.de> <20130206225150.GL17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130206225150.GL17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:DjYfsF0vxA55wR0oJD3KQroQOqbp9tEFxQ+JrjKZmOC
 HhF0kssOnEnB+YKelrcILjhmGQowsnCWIyKWmPqYFK6NLs+IYc
 Rg7bExBRzhyAxaUrbStPx04xghKPuFQxnVTE1xDl/B+LSGBrJN
 ZQEo84wWAoqMqM+5pobDANhHUv8PJvZbHu0fBemuCLRVWZviKr
 8TfEmZPiIuISvR9INDBHaVRQhYC5rnj37JhXlgJDFU2HmRDnIa
 KYvtmIX7yyK8AJ2ruuo6nPK1fosi5MWcynpfXluc/keb3MXyHn
 0qIAG2MQ4JF2hX5wkXYaC3wDYuIlCSJx+Ma2viN9Zgmm5TQoFz
 LA5im5+Qj8286uPbIHWA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.02.2013 23:51, schrieb Russell King - ARM Linux:
> On Wed, Feb 06, 2013 at 11:43:10PM +0100, André Hentschel wrote:
>> There are more and more applications coming to WinRT, Wine could support them,
>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>> This register must be preserved per thread instead of being cleared.
> 
> I'd prefer this was done a little more sensitively to those CPUs where
> loads/stores are expensive, namely:
> 
>> +
>> +	@ preserve TPIDRURW register state
>> +	get_tls2	r3, r4, r5
>> +	str	r3, [r1, #TI_TP2_VALUE]
>> +	ldr	r3, [r2, #TI_TP2_VALUE]
>> +	set_tls2	r3, r4, r5
> 
> those two loads/stores get omitted from the thread switching if the CPU
> doesn't support it.  Do you think that's something you could do?

No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?


-- 

Best Regards, André Hentschel
