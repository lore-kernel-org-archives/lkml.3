Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaLFAPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 19:15:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaLFAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 19:15:49 -0500
Date: Fri, 5 Dec 2014 16:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "George Spelvin" <linux@horizon.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VERIFY_OCTAL_PERMISSIONS needs <linux/bug.h>
Message-Id: <20141205161548.dfa3bc0648b2109ebed9b1ae@linux-foundation.org>
In-Reply-To: <20141206000759.14606.qmail@ns.horizon.com>
References: <20141206000759.14606.qmail@ns.horizon.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Dec 2014 19:07:59 -0500 "George Spelvin" <linux@horizon.com> wrote:

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
> 
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

Absolutely everything includes kernel.h so this might have measurable
build-time impact.

VERIFY_OCTAL_PERMISSIONS() sticks out like a sore thumb in kernel.h. 
How about we move it into sysfs.h?
