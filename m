Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3JJH0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:26:35 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:40933 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3JJH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:26:33 -0400
Date: Thu, 10 Oct 2013 09:25:08 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] s390: include: asm: atomic.h: use 'unsigned int'
 instead of 'unsigned long' for atomic_*_mask()
Message-ID: <20131010072508.GA4383@osiris>
References: <52561137.3070608@asianux.com>
 <5256117A.4000009@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5256117A.4000009@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101007-2966-0000-0000-000008FEDAA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:31:22AM +0800, Chen Gang wrote:
> The type of 'v->counter' is always 'int', and related inline assembly
> code also process 'int', so use 'unsigned int' instead of 'unsigned
> long' for the 'mask'.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/s390/include/asm/atomic.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
> index a62ed2d..12c5ec1 100644
> --- a/arch/s390/include/asm/atomic.h
> +++ b/arch/s390/include/asm/atomic.h
> @@ -113,12 +113,12 @@ static inline void atomic_add(int i, atomic_t *v)
>  #define atomic_dec_return(_v)		atomic_sub_return(1, _v)
>  #define atomic_dec_and_test(_v)		(atomic_sub_return(1, _v) == 0)
> 
> -static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
> +static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
>  {

Applied. Thanks!

