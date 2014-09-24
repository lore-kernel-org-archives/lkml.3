Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaIXSmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:42:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34560 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaIXSmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:42:46 -0400
Message-ID: <54231088.8030000@zytor.com>
Date: Wed, 24 Sep 2014 11:42:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org> <5422E8D0.5080705@zytor.com> <5422EA13.1080706@nexus-software.ie> <5422EC30.10206@nexus-software.ie>
In-Reply-To: <5422EC30.10206@nexus-software.ie>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 09:07 AM, Bryan O'Donoghue wrote:
>>
>> So __flush_tlb_all(); will do nothing but that's OK since load_cr3()
>> already flushed the TLB - including any PTE with PGE set
> 
> I take your point though.
> 
> It's probably better to be explicit and do the whole
> 
> if (quark)
>     __flush_tlb();
> else
>     __flush_tlb_all();
> 
> So that we aren't relying on the side effects of the previous statement.
> 

Well, we need a comment at least.

	-hpa


