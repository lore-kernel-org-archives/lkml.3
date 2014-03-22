Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaCVKB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:01:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaCVKBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:01:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: behanw@converseincode.com
Subject: Re: [PATCH] LLVMLinux: Remove warning about returning an uninitialized variable
Date: Sat, 22 Mar 2014 11:01:16 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
References: <1395470329-15065-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395470329-15065-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403221101.16961.arnd@arndb.de>
X-Provags-ID: V02:K0:Z7ILGFrykGdXJ92pOXMUEgjUcDzxAuIrwNpVqFJLJRt
 nUdrSjYXeS4eO4/R+Rf/lxaEt4BkvchQXA4CHfP0Al8rMu8fEO
 m6i0byWq15VfC+24XmiFNJdqzxdwtybuGRhOa2KzBh1KrqncXV
 nCQd/2LuHQSz8+gzHdk7ZItyhys3kU61Zav4t2hP93NnMnaGks
 h3cBQllKwr9y36xnZjOlZjSwTh8fiyY7Xgr9xnWAzOSuxFZmmN
 q6Gfj9N/YNKA1pmwXN6YziFJ4Upuu6lov3VVjhOGmsGuGICNpr
 HxkkAX/P6xWRWAzlbVCarYijsFYfQ6nj0NuUf5EFahimRyj/f9
 +jMROy4SP/iVHHGxpvHVTQYIFVjBV2nTBhvpteo7u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2014, behanw@converseincode.com wrote:
> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
> index d8d4c89..4c41bb8 100644
> --- a/include/asm-generic/cmpxchg-local.h
> +++ b/include/asm-generic/cmpxchg-local.h
> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
>                 break;
>         default:
>                 wrong_size_cmpxchg(ptr);
> +               prev = 0;
>         }
>         raw_local_irq_restore(flags);
>         return prev;


How about using __unreachable() instead to annotate the fact that you won't
get here?

	Arnd
