Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaIXP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:58:18 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:36716 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbaIXP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:58:14 -0400
Message-ID: <5422EA13.1080706@nexus-software.ie>
Date: Wed, 24 Sep 2014 16:58:11 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org> <5422E8D0.5080705@zytor.com>
In-Reply-To: <5422E8D0.5080705@zytor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> I believe there is one more change needed: there is a __flush_tlb_all()
> in the early code which gets executed before the above code runs; the
> easiest fix is to just add a __flush_tlb() immediately after it.
>
> This should have been pushed upstream, and not stayed in the BSP kernel.

Peter.

You're talking about void __init setup_arch() right ?

The code looks like this

load_cr3(swapper_pg_dir);
__flush_tlb_all();

Note that on Quark the method to invalidate the TLB is by reloading CR3 
- which is immediately prior to __flush_tlb_all();

So __flush_tlb_all(); will do nothing but that's OK since load_cr3() 
already flushed the TLB - including any PTE with PGE set


Best,
Bryan
