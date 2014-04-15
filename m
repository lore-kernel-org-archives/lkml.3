Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaDOBhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:37:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14537 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaDOBhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:37:15 -0400
X-AuditID: cbfee68f-b7f156d00000276c-47-534c8d47028a
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Steve Capper'" <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        kgene.kim@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414151333.GA29654@linaro.org>
In-reply-to: <20140414151333.GA29654@linaro.org>
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Date: Tue, 15 Apr 2014 10:37:11 +0900
Message-id: <001a01cf584b$38945370$a9bcfa50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQILdni68u70DkxPk4mJeDBA1L/NRAGceXZlmozCy2A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zga57r0+wwdM58hZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXx
	cNk2poKdQhUbfz1mb2A8ztfFyMkhIWAi8fzyeTYIW0ziwr31QDYXh5DAMkaJvsnvGGGK1nde
	ZYFITGeUmLn5EFhCSOAPo8SUr+wgNpuApsSjuz1gtoiAjsTJa22sIA3MAh3MEjf6ljJBNMRL
	rPh3B8zmFDCQmDHlJpgtLOAjcXP5F7BmFgFViY/fV7CA2LwClhING5azQdiCEj8m3wOLMwto
	SazfeZwJwpaX2LzmLTPEpQoSO86+ZoQ4wkrixLKPjBA1IhL7XoB8wwVUM5dDYsm+b1DLBCS+
	TT4ENJQDKCErsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPWK
	E3OLS/PS9ZLzczcxQpJA/w7GuwesDzEmA62fyCwlmpwPTCJ5JfGGxmZGFqYmpsZG5pZmpAkr
	ifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExy7tsxpZfk/qajnTFdHkonCu/l+62
	xK58ceMm1murMiNWVF6wmK+6eP/2xVW5OsK6+3SsD+1OOWxqeyn1a077AuOIY9L2uvyBW2rT
	NeeF7v7L/Xl157341MMBXqfX3vB/FnfY7fH/X8fZ7u/blZlV2lA0Zcs39UfHVRaH2Oia5kUs
	mf3xQP8EJZbijERDLeai4kQA7OI6GhgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQV33Xp9gg5VtUhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4+GybUwFO4UqNv56zN7AeJyvi5GTQ0LARGJ951UWCFtM
	4sK99WxdjFwcQgLTGSVmbj7ECJIQEvjDKDHlKzuIzSagKfHobg+YLSKgI3HyWhsrSAOzQAez
	xI2+pUwQDfESK/7dAbM5BQwkZky5CWYLC/hI3Fz+BayZRUBV4uP3FWCbeQUsJRo2LGeDsAUl
	fky+BxZnFtCSWL/zOBOELS+xec1bZohLFSR2nH3NCHGElcSJZR8ZIWpEJPa9eMc4gVFoFpJR
	s5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeYZ9I7GFc1WBxiFOBg
	VOLhnfDOO1iINbGsuDL3EKMEB7OSCO/rZJ9gId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4H
	pr+8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBs2sCxoGJC
	2RUGTkUFJh61d/6xD1ZabmNmkBcNi1tze90bm0vrd5/r21Rd3hvYrHnsoltCiNYsjt9m78oy
	lRkeult/774lc73jh+ceK9HpDe+9FmTXrlXc7Zz0Z2v7f4cdk3VVF+Rtuzd/V+0kGYey1TJP
	7wbf41+j3ZZ56eettRv3yG/j5bivxFKckWioxVxUnAgAFrRtKHUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 12:14 AM, Steve Capper wrote:
> On Mon, Apr 14, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
> > This patch implements 4 levels of translation tables since 3 levels of
> > page tables with 4KB pages cannot support 40-bit physical address
> > space described in [1] due to the following issue.
> >
> > It is a restriction that kernel logical memory map with 4KB + 3 levels
> > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> > 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> > mapping for this region in map_mem function since __phys_to_virt for
> > this region reaches to address overflow.
> >
> > If SoC design follows the document, [1], over 32GB RAM would be placed
> > from 544GB. Even 64GB system is supposed to use the region from 544GB
> > to 576GB for only 32GB RAM. Naturally, it would reach to enable 4
> > levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> >
> > However, it is recommended 4 levels of page table should be only
> > enabled if memory map is too sparse or there is about 512GB RAM.
> >
> > References
> > ----------
> > [1]: Principle of ARM Memory Maps, White Paper, Issue C
> >

[ ... ]

> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c index
> > 6b7e895..321f569 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -222,9 +222,17 @@ static void __init alloc_init_pmd(pud_t *pud,
> > unsigned long addr,  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> >  				  unsigned long end, unsigned long phys)  {
> > -	pud_t *pud = pud_offset(pgd, addr);
> > +	pud_t *pud;
> >  	unsigned long next;
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
> > +		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
> > +		pgd_populate(&init_mm, pgd, pud);
> > +	}
> > +#endif
> 
> We don't need this #ifdef block, as pgd_none and pgd_bad should be zero when we have fewer than 4
> levels.

This block is needed to cover the third RAM region from 544GB to 1024GB
described in the document [1].

A single PGD can cover only up to 512GB with 4KB+4Level. In other words,
kernel would reach to panic if a system has RAM over 512GB memory map space.
That is why pgd_none should be handled.

Best Regards
Jungseok Lee

