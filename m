Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3HFGBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:01:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3HFGBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:01:16 -0400
Date: Mon, 5 Aug 2013 22:59:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Message-Id: <20130805225949.82a82dda.akpm@linux-foundation.org>
In-Reply-To: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
References: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Aug 2013 15:09:35 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Use standard gcc __attribute__((alias(foo))) to define
> the syscall aliases instead of custom assembler macros.
> 
> This is far cleaner, and also fixes my LTO kernel build.

I wonder what gcc version this was added in.  Seems fairly longstanding.

>  	{								\
>  		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
>  	}								\
> -	SYSCALL_ALIAS(compat_sys##name, compat_SyS##name);		\

I think we can remove the SYSCALL_ALIAS definitions?


