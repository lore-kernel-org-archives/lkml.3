Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaLJLUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:20:43 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45119 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaLJLUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:20:41 -0500
Message-ID: <54882C83.5010803@de.ibm.com>
Date: Wed, 10 Dec 2014 12:20:35 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the access_once tree
References: <20141210192035.2e5d80ff@canb.auug.org.au>
In-Reply-To: <20141210192035.2e5d80ff@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121011-0009-0000-0000-00000252B790
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2014 um 09:20 schrieb Stephen Rothwell:
> Hi Christian,
> 
> After merging the access_once tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> In file included from /scratch/sfr/next/include/uapi/linux/stddef.h:1:0,
>                  from /scratch/sfr/next/include/linux/stddef.h:4,
>                  from /scratch/sfr/next/include/uapi/linux/posix_types.h:4,
>                  from /scratch/sfr/next/include/uapi/linux/types.h:13,
>                  from /scratch/sfr/next/include/linux/types.h:5,
>                  from /scratch/sfr/next/include/linux/smp.h:10,
>                  from /scratch/sfr/next/include/linux/kernel_stat.h:4,
>                  from /scratch/sfr/next/mm/memory.c:41:
> In function '__read_once_size',
>     inlined from 'handle_pte_fault' at /scratch/sfr/next/mm/memory.c:3192:10,
>     inlined from '__handle_mm_fault' at /scratch/sfr/next/mm/memory.c:3324:2,
>     inlined from 'handle_mm_fault' at /scratch/sfr/next/mm/memory.c:3353:6:
> /scratch/sfr/next/include/linux/compiler.h:206:3: warning: call to 'data_access_exceeds_word_size' declared with attribute warning: data access exceeds word size and won't be atomic
>    data_access_exceeds_word_size();
>    ^
> mm/built-in.o: In function `handle_mm_fault':
> (.text+0x283a0): undefined reference to `data_access_exceeds_word_size'
> 
> I hate dropped the access_once tree again today.

hate dropped? typo or bad mood? ;-)

I fixed this two-ways 
1: a real bug: I did not provide data_access_exceeds_word_size
2: a change in semantics: change the memory.c rework to a barrier as if should be enough

Can you retry (I added ppc44x_defconfig to my cross compile test)?

Christian

Sorry for being such a pain, but the access_once rework will be prone to compile errors

