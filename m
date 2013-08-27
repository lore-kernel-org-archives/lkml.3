Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3H0KuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:50:11 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52839 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752115Ab3H0KuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:50:09 -0400
Date: Tue, 27 Aug 2013 11:49:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: move elf notes into readonly segment
Message-ID: <20130827104949.GE19897@arm.com>
References: <1377271002.7359.2.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377271002.7359.2.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:16:42PM +0100, Mark Salter wrote:
> The current vmlinux.lds.S places the notes sections between the
> end of rw data and start of bss. This means that _edata doesn't
> really point to the end of data. Since notes are read-only, this
> patch moves them to the read-only segment so that _edata does
> point to the end of initialized rw data.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/kernel/vmlinux.lds.S | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index f5e5574..f8ab9d8 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -71,6 +71,7 @@ SECTIONS
>  
>  	RO_DATA(PAGE_SIZE)
>  	EXCEPTION_TABLE(8)
> +	NOTES
>  	_etext = .;			/* End of text and rodata section */
>  
>  	. = ALIGN(PAGE_SIZE);
> @@ -122,8 +123,6 @@ SECTIONS
>  	}
>  	_edata_loc = __data_loc + SIZEOF(.data);
>  
> -	NOTES
> -
>  	BSS_SECTION(0, 0, 0)
>  	_end = .;

The _edata is set before NOTES, so I don't fully understand where the
problem is.

-- 
Catalin
