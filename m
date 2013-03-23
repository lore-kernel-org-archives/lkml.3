Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab3CWLvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:51:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43131 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3CWLvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:51:20 -0400
Date: Sat, 23 Mar 2013 12:51:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323115115.GA10821@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364001923-10796-13-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 06:25:06PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For some locks that have a low chance of not aborting it's
> best to just disable transactions.
> 
> Add a counter to thread_info to allow to disable tranasctions
> for the current task.
> 
> I originally experimented with more complicated solutions,
> like a magic spinlock type to disable with magic type matching,
> but that was very intrusive in the locking code.
> 
> This setup -- while adding a few more instructions -- is more
> flexible and seems to work quite nicely.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/thread_info.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index 2cd056e..91bb84e 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -39,6 +39,7 @@ struct thread_info {
>  						*/
>  	__u8			supervisor_stack[0];
>  #endif
> +	unsigned		notxn;		/* transactions are disabled */

This surely can be a bitfield like the other two below. It is basically
begging to be one.

>  	unsigned int		sig_on_uaccess_error:1;
>  	unsigned int		uaccess_err:1;	/* uaccess failed */
>  };

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
