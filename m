Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaGLCFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:05:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbaGLCFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:05:11 -0400
Message-ID: <53C097BC.7070909@zytor.com>
Date: Fri, 11 Jul 2014 19:04:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
In-Reply-To: <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:29 AM, Andy Lutomirski wrote:
> diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
> index 076b11f..df9908b 100644
> --- a/arch/x86/include/uapi/asm/sigcontext.h
> +++ b/arch/x86/include/uapi/asm/sigcontext.h
> @@ -177,8 +177,8 @@ struct sigcontext {
>  	__u64 rip;
>  	__u64 eflags;		/* RFLAGS */
>  	__u16 cs;
> -	__u16 gs;
> -	__u16 fs;
> +	__u16 __pad2;		/* Was called gs, but was always zero. */
> +	__u16 __pad1;		/* Was called fs, but was always zero. */
>  	__u16 ss;
>  	__u64 err;
>  	__u64 trapno;

I'm just wondering if this is likely to cause compile error in existing
code.  I guess worst case we can just revert this patch...

	-hpa

