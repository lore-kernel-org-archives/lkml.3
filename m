Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaIZKGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:06:55 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48318 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaIZKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:06:52 -0400
Message-ID: <54253AB3.7000307@de.ibm.com>
Date: Fri, 26 Sep 2014 12:06:43 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3.12 040/142] s390/locking: Reenable optimistic spinning
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz> <f008331068945523ff12ff13f6d07d7303e0e8a9.1411724723.git.jslaby@suse.cz>
In-Reply-To: <f008331068945523ff12ff13f6d07d7303e0e8a9.1411724723.git.jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092610-5024-0000-0000-0000017070C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 11:44 AM, Jiri Slaby wrote:
> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.

I just checked.

It seems that the referenced commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc
(locking/mutex: Disable optimistic spinning on some architectures)
is not part of 3.12-stable. So this fix is not (yet) necessary.

This is probably also true for other stable backports. It seems that Kconfig just ignores non-existent entries for SELECT, so it does not hurt either.

If you are going to backport that commit later on then it might make sense to keep this patch in, otherwise not.

Christian

> 
> 
> ===============
> 
> commit 36e7fdaa1a04fcf65b864232e1af56a51c7814d6 upstream.
> 
> commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc (locking/mutex: Disable
> optimistic spinning on some architectures) fenced spinning for
> architectures without proper cmpxchg.
> There is no need to disable mutex spinning on s390, though:
> The instructions CS,CSG and friends provide the proper guarantees.
> (We dont implement cmpxchg with locks).
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  arch/s390/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 6671e8db1861..faa97bd4948e 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -93,6 +93,7 @@ config S390
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQ
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>  	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
> +	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select BUILDTIME_EXTABLE_SORT
> 

