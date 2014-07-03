Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbaGCV5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:57:45 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44598 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaGCV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:57:43 -0400
Date: Thu, 3 Jul 2014 14:57:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nicholas Krause <xerofoify@gmail.com>
cc: monstr@monstr.eu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: fixes includes in sigcontext.h
In-Reply-To: <1404423935-5287-1-git-send-email-xerofoify@gmail.com>
Message-ID: <alpine.DEB.2.02.1407031456430.10658@chino.kir.corp.google.com>
References: <1404423935-5287-1-git-send-email-xerofoify@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Nicholas Krause wrote:

> diff --git a/arch/microblaze/include/uapi/asm/sigcontext.h b/arch/microblaze/include/uapi/asm/sigcontext.h
> index 55873c8..1180d9b 100644
> --- a/arch/microblaze/include/uapi/asm/sigcontext.h
> +++ b/arch/microblaze/include/uapi/asm/sigcontext.h
> @@ -9,8 +9,7 @@
>  #ifndef _ASM_MICROBLAZE_SIGCONTEXT_H
>  #define _ASM_MICROBLAZE_SIGCONTEXT_H
>  
> -/* FIXME should be linux/ptrace.h */
> -#include <asm/ptrace.h>
> +#include <linux/ptrace.h>
>  
>  struct sigcontext {
>  	struct pt_regs regs;

Umm, does this even compile?  How does sigcontext.h get the definition of 
struct pt_regs?  Seems like it would be better to just do a forward 
declaration.
