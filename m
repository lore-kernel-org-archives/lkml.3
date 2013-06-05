Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3FEXsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:48:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3FEXsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:48:06 -0400
Date: Wed, 5 Jun 2013 16:48:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        devel@driverdev.osuosl.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] clean up scary strncpy(dst, src, strlen(src)) uses
Message-Id: <20130605164804.8071867d28c1f20cad8d7d2a@linux-foundation.org>
In-Reply-To: <20130531161807.GA9536@www.outflux.net>
References: <20130531161807.GA9536@www.outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 09:18:07 -0700 Kees Cook <keescook@chromium.org> wrote:

> Fix various weird constructions of strncpy(dst, src, strlen(src)). Length
> limits should be about the space available in the destination, not
> repurposed as a method to either always include or always exclude
> a trailing NULL byte. Either the NULL should always be copied
> (using strlcpy), or it should not be copied (using something like
> memcpy). Readable code should not depend on the weird behavior of strncpy
> when it hits the length limit. Better to avoid the anti-pattern entirely.
> 
> ...
>
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -23,6 +23,7 @@
>  #include <sys/socket.h>
>  #include <sys/wait.h>
>  #include <signal.h>
> +#include <bsd/string.h>
>  
>  #include <linux/genetlink.h>
>  #include <linux/taskstats.h>
> @@ -299,7 +300,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'C':
>  			containerset = 1;
> -			strncpy(containerpath, optarg, strlen(optarg) + 1);
> +			strlcpy(containerpath, optarg, sizeof(containerpath));
>  			break;
>  		case 'w':
>  			logfile = strdup(optarg);

Documentation/accounting/getdelays.c:26:24: fatal error: bsd/string.h: No such file or directory

I'll revert this part.
