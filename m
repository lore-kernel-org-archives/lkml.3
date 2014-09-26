Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaIZRfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:35:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaIZRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:35:04 -0400
Message-ID: <5425A3C4.3080509@infradead.org>
Date: Fri, 26 Sep 2014 10:35:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Add strictinit to disable init= fallbacks
References: <0df43a7e86c386129905b679014acd1cd7b61220.1411692874.git.luto@amacapital.net>
In-Reply-To: <0df43a7e86c386129905b679014acd1cd7b61220.1411692874.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 17:55, Andy Lutomirski wrote:
> If a user puts init=/whatever on the command line and /whatever
> can't be run, then the kernel will try a few default options before
> giving up.  If init=/whatever came from a bootloader prompt, then
> this probably makes sense.  On the other hand, if it comes from a
> script (e.g. a tool like virtme or perhaps a future kselftest
> script), then the fallbacks are likely to exist, but they'll do the
> wrong thing.  For example, they might unexpectedly invoke systemd.
> 
> This adds a new option called strictinit.  If init= and strictinit
> are both set, and the init= binary is not executable, then the
> kernel will panic immediately.  If strictinit is set but init= is
> not set, then strictinit will have no effect, because the only real
> alternative would be to panic regardless of the contents of the root
> fs.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  Documentation/kernel-parameters.txt |  8 ++++++++
>  init/main.c                         | 10 ++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 10d51c2f10d7..60f8b3a7a506 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3236,6 +3236,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	stifb=		[HW]
>  			Format: bpp:<bpp1>[:<bpp2>[:<bpp3>...]]
>  
> +	strictinit	[KNL,BOOT]
> +			Normally, the kernel can't find the init binary

			        , if the kernel

> +			specified by rdinit= and/or init=, then it will
> +			try several fallbacks.  If strictinit is set
> +			and the value specified by init= does not work,
> +			then the kernel will panic instead.
> +			This has no effect if init= is not specified.
> +
>  	sunrpc.min_resvport=
>  	sunrpc.max_resvport=
>  			[NFS,SUNRPC]


-- 
~Randy
