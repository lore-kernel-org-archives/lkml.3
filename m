Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaFLUBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:01:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaFLUBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:01:53 -0400
Message-ID: <539A071B.2080101@zytor.com>
Date: Thu, 12 Jun 2014 13:01:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Kui Zhang <kuizhang@gmail.com>
CC: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 2/3] doc,vdso: Make vDSO examples more portable
References: <cover.1402598632.git.luto@amacapital.net> <87f62cc3db04047f9edbf7bacac059396d7112f1.1402598632.git.luto@amacapital.net>
In-Reply-To: <87f62cc3db04047f9edbf7bacac059396d7112f1.1402598632.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 11:47 AM, Andy Lutomirski wrote:
>  
> +#include <asm/bitsperlong.h>
> +

This isn't portable in any way.  This is probably not the right way to
do this.

The portable way to do this would be something like:

#include <limits.h>

#if ULONG_MAX > 0xffffffffUL
# define ELF_BITS 64
#else
# define ELF_BITS 32
#endif

There is also the option of looking for either __LP64__ or __ILP32__
which isn't 100% portable but works with all newer versions of gcc:

#ifndef ELF_BITS
# ifdef __LP64__
#  define ELF_BITS 64
# elif defined(__ILP32__)
#  define ELF_BITS 32
# else
#  error "Unknown size, please define ELF_BITS"
# endif
#endif

... or something like that.

	-hpa

