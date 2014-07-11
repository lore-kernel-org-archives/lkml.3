Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaGKSMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:12:22 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49447 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaGKSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:12:15 -0400
Date: Fri, 11 Jul 2014 20:12:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
Message-ID: <20140711181212.GT18735@two.firstfloor.org>
References: <cover.1405095200.git.luto@amacapital.net>
 <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
> index 076b11f..df9908b 100644
> --- a/arch/x86/include/uapi/asm/sigcontext.h
> +++ b/arch/x86/include/uapi/asm/sigcontext.h

I don't think renaming fields in uapi/asm is acceptable. These
are likely used by user programs and you'll break compiles.

-Andi

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

-- 
ak@linux.intel.com -- Speaking for myself only.
