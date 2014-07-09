Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaGIXaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:30:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaGIXaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:30:17 -0400
Date: Wed, 9 Jul 2014 16:30:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: fix vDSO build
Message-Id: <20140709163015.96c76a7b0e84632bc006fda0@linux-foundation.org>
In-Reply-To: <53B5861E02000078000204D1@mail.emea.novell.com>
References: <53B5861E02000078000204D1@mail.emea.novell.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2014 15:34:38 +0100 "Jan Beulich" <JBeulich@suse.com> wrote:

> Certain ld versions (observed with 2.20.0) put an empty .rela.dyn
> section into shared object files, breaking the assumption on the number
> of sections to be copied to the final output. Simply discard any empty
> SHT_REL and SHT_RELA sections to address this.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/vdso2c.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- 3.16-rc3/arch/x86/vdso/vdso2c.h
> +++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vdso2c.h
> @@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struc
>  	uint64_t flags = GET_LE(&in->sh_flags);
>  
>  	bool copy = flags & SHF_ALLOC &&
> +		(GET_LE(&in->sh_size) ||
> +		 (GET_LE(&in->sh_type) != SHT_RELA &&
> +		  GET_LE(&in->sh_type) != SHT_REL)) &&
>  		strcmp(name, ".altinstructions") &&
>  		strcmp(name, ".altinstr_replacement");

Tested-by: Andrew Morton <akpm@linux-foundation.org>

(hint)
