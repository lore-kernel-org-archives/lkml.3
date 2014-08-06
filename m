Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaHFIfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:35:04 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:38384 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaHFIe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:34:59 -0400
Date: Wed, 6 Aug 2014 10:34:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] s390/locking: Reenable optimistic spinning
Message-ID: <20140806083453.GA4983@osiris>
References: <1407225471-14875-1-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407225471-14875-1-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080608-0342-0000-0000-000000AA38F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:57:51AM +0200, Christian Borntraeger wrote:
> commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc (locking/mutex: Disable
> optimistic spinning on some architectures) fenced spinning for
> architectures without proper cmpxchg.
> There is no need to disable mutex spinning on s390, though:
> The instructions CS,CSG and friends provide the proper guarantees.
> (We dont implement cmpxchg with locks).
> 
> Please note: This is a quick fix for s390, suitable for stable
> as 3.16 unintenionally disabled optimistic spinning.
> 
> The proper fix is probably to use ARCH_HAVE_NMI_SAFE_CMPXCHG
> instead of introducing ARCH_SUPPORTS_ATOMIC_RMW.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CC: <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: stable@vger.kernel.org
> ---
>  arch/s390/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 9a0ea87..eab3c32 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -63,6 +63,7 @@ config S390
>  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_INLINE_READ_LOCK
>  	select ARCH_INLINE_READ_LOCK_BH
>  	select ARCH_INLINE_READ_LOCK_IRQ

This can go in via the s390 tree. I applied your patch and changed
it a bit to keep Kconfig sorted.
Thanks!

