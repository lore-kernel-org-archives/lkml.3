Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934892Ab3BNT0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:26:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55522 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab3BNT0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:26:09 -0500
Message-ID: <511D3A33.20105@zytor.com>
Date: Thu, 14 Feb 2013 11:25:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 11/11] scripts/sortextable: silence script output
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-12-git-send-email-arnd@arndb.de>
In-Reply-To: <1360849767-1463135-12-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 05:49 AM, Arnd Bergmann wrote:
> The exception table sorter outputs one line every time
> it gets called, e.g. 'sort done marker at 66dc00', which
> is slightly annoying when doing 'make -s' which is otherwise
> completely silent. Since that output is not helpful to
> most people building the kernel, turn it off by default.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: David Daney <david.daney@cavium.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>   scripts/sortextable.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/sortextable.h b/scripts/sortextable.h
> index e4fd45b..f5eb43d 100644
> --- a/scripts/sortextable.h
> +++ b/scripts/sortextable.h
> @@ -182,7 +182,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>   		_r(&sort_needed_sym->st_value) -
>   		_r(&sort_needed_sec->sh_addr);
>
> -#if 1
> +#if 0
>   	printf("sort done marker at %lx\n",
>   	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
>   #endif
>

Acked-by: H. Peter Anvin <hpa@zytor.com>

... or just kill the printf entirely.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

