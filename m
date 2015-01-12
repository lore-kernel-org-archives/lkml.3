Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbbALXOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:14:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:29269 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbALXNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:13:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,745,1413270000"; 
   d="scan'208";a="668710920"
Message-ID: <54B45514.3070603@linux.intel.com>
Date: Mon, 12 Jan 2015 15:13:24 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 3.19 v2 1/3] x86: Fix off-by-one in the instruction decoder
 length checks
References: <cover.1421103159.git.luto@amacapital.net> <602a94627fedaab4e339088d633b72174caf14c9.1421103159.git.luto@amacapital.net>
In-Reply-To: <602a94627fedaab4e339088d633b72174caf14c9.1421103159.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 03:04 PM, Andy Lutomirski wrote:
> diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
> index 2480978b31cc..1313ae6b478b 100644
> --- a/arch/x86/lib/insn.c
> +++ b/arch/x86/lib/insn.c
> @@ -28,7 +28,7 @@
>  
>  /* Verify next sizeof(t) bytes can be on the same instruction */
>  #define validate_next(t, insn, n)	\
> -	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
> +	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
>  
>  #define __get_next(t, insn)	\
>  	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })

This issue should already be handled by this patch:

http://git.kernel.org/tip/0f363b250b15af0f218bb2876d101fe5cd413f8b
