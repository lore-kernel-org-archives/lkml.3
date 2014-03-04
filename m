Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbaCDV0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:26:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbaCDV0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:26:05 -0500
Date: Tue, 4 Mar 2014 13:26:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH 1/1] mm: use macros from compiler.h instead of
 __attribute__((...))
Message-Id: <20140304132604.5be1b967068f8e03820d2169@linux-foundation.org>
In-Reply-To: <1393767598-15954-2-git-send-email-gidisrael@gmail.com>
References: <1393767598-15954-1-git-send-email-gidisrael@gmail.com>
	<1393767598-15954-2-git-send-email-gidisrael@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Mar 2014 19:09:58 +0530 Gideon Israel Dsouza <gidisrael@gmail.com> wrote:

> To increase compiler portability there is <linux/compiler.h> which
> provides convenience macros for various gcc constructs.  Eg: __weak
> for __attribute__((weak)).  I've replaced all instances of gcc
> attributes with the right macro in the memory management
> (/mm) subsystem.
> 
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -13,6 +13,7 @@
>  #include <linux/nodemask.h>
>  #include <linux/pagemap.h>
>  #include <linux/mempolicy.h>
> +#include <linux/compiler.h>

It may be overdoing things a bit to explicitly include compiler.h. 
It's hard to conceive of any .c file which doesn't already include it.
