Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaJASfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:35:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42854 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaJASfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:35:44 -0400
Message-ID: <542C496F.80003@zytor.com>
Date: Wed, 01 Oct 2014 11:35:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
CC: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH v3 2/2] x86_64: Don't save flags on context switch
References: <cover.1412187233.git.luto@amacapital.net> <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
In-Reply-To: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 11:28 AM, Andy Lutomirski wrote:
>  
>  #define __EXTRA_CLOBBER  \
>  	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
> -	  "r12", "r13", "r14", "r15"
> +	  "r12", "r13", "r14", "r15", "flags"
>  

I was under the impression that gcc *always* assumes the flags were
clobbered for an asm statement.  Otherwise I think we'd have a lot of
problems.

	-hpa


