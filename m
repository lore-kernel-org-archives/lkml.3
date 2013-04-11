Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936097Ab3DKPRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:17:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab3DKPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:17:05 -0400
Message-ID: <5166D3F8.2050901@oracle.com>
Date: Thu, 11 Apr 2013 11:17:12 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: hpa@zytor.com
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jwboyer@redhat.com, tglx@linutronix.de,
        bp@suse.de
Subject: Re: [tip:x86/urgent] x86, mm: Patch out arch_flush_lazy_mmu_mode()
 when running on bare metal
References: <1364045796-10720-2-git-send-email-konrad.wilk@oracle.com> <tip-511ba86e1d386f671084b5d0e6f110bb30b8eeb2@git.kernel.org>
In-Reply-To: <tip-511ba86e1d386f671084b5d0e6f110bb30b8eeb2@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 08:30 PM, tip-bot for Boris Ostrovsky wrote:
> Commit-ID:  511ba86e1d386f671084b5d0e6f110bb30b8eeb2
> Gitweb:     http://git.kernel.org/tip/511ba86e1d386f671084b5d0e6f110bb30b8eeb2
> Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
> AuthorDate: Sat, 23 Mar 2013 09:36:36 -0400
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 10 Apr 2013 11:25:10 -0700
>
> x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
>
> Invoking arch_flush_lazy_mmu_mode() results in calls to
> preempt_enable()/disable() which may have performance impact.
>
> Since lazy MMU is not used on bare metal we can patch away
> arch_flush_lazy_mmu_mode() so that it is never called in such
> environment.
>
> [ hpa: the previous patch "Fix vmalloc_fault oops during lazy MMU
>    updates" may cause a minor performance regression on
>    bare metal.  This patch resolves that performance regression.  It is
>    somewhat unclear to me if this is a good -stable candidate. ]

I think this

    https://lkml.org/lkml/2013/2/26/420

was also part of lazy mmu set of patches but is missing in the latest 
batch of
commits.

-boris

