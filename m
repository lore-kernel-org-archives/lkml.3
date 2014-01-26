Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaAZVMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:12:42 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51840 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:12:40 -0500
Date: Sun, 26 Jan 2014 13:12:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhihui Zhang <zzhsuny@gmail.com>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use LOAD_PHYSICAL_ADDR in vmlinux.lds.S
In-Reply-To: <1390767194-28654-1-git-send-email-zzhsuny@gmail.com>
Message-ID: <alpine.DEB.2.02.1401261311270.26515@chino.kir.corp.google.com>
References: <1390767194-28654-1-git-send-email-zzhsuny@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Zhihui Zhang wrote:

> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index da6b35a..e81bf49 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -81,11 +81,10 @@ PHDRS {
>  
>  SECTIONS
>  {
> -#ifdef CONFIG_X86_32
>          . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
> +#ifdef CONFIG_X86_32
>          phys_startup_32 = startup_32 - LOAD_OFFSET;
>  #else
> -        . = __START_KERNEL;
>          phys_startup_64 = startup_64 - LOAD_OFFSET;
>  #endif
>  

Makes sense, but any reason to not make LOAD_PHYSICAL_ADDR to use ALIGN()?

(You'll also want to prefix the patch title in the subject line with 
"x86, boot:" and cc x86@kernel.org on patches like this.)
