Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaLFAMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 19:12:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:34997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaLFAMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 19:12:07 -0500
Message-ID: <548249D1.7000008@infradead.org>
Date: Fri, 05 Dec 2014 16:12:01 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, rusty@rustcorp.com.au
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VERIFY_OCTAL_PERMISSIONS needs <linux/bug.h>
References: <20141206000759.14606.qmail@ns.horizon.com>
In-Reply-To: <20141206000759.14606.qmail@ns.horizon.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/14 16:07, George Spelvin wrote:
> It is possible to include <linux/kernel.h> and try to use
> VERIFY_OCTAL_PERMISSIONS, then puke because BUILD_BUG_ON_ZERO
> isn't defined.
> 
> I hit this via:
> 
> #include <linux/moduleparam.h>
> module_param(verbose, bool, 0);
> 
> IMHO, except in documented special cases, header files should
> #include their own macros' dependencies.

Yes.  Documentation/SubmitChecklist #1:

1: If you use a facility then #include the file that defines/declares
   that facility.  Don't depend on other header files pulling in ones
   that you use.


Thanks.

> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  include/linux/kernel.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> I'm not quite sure who to send this via.  Rusty, you touched
> VERIFY_OCTAL_PERMISSIONS last.  Should I send this via you, or collect
> acks and include it in the patch series I'm working on that wants this?
> 
> The workaround is easy enough, but I'd rather fix it than let cruft
> like this accumulate.
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f55..afb81c1a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -12,6 +12,7 @@
>  #include <linux/typecheck.h>
>  #include <linux/printk.h>
>  #include <linux/dynamic_debug.h>
> +#include <linux/bug.h>
>  #include <asm/byteorder.h>
>  #include <uapi/linux/kernel.h>
>  
> 


-- 
~Randy
