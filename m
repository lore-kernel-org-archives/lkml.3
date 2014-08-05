Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaHEUM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:12:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:10879 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaHEUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:12:56 -0400
X-CheckPoint: {53E13AC8-0-2100090A-C0000000}
Message-ID: <53E13AC7.1030406@tilera.com>
Date: Tue, 5 Aug 2014 16:12:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wang Sheng-Hui <shhuiw@gmail.com>
CC: Daniel Walter <dwalter@google.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: setup.c:  Cleaning up missing null-terminate
 in conjunction with strncpy
References: <1406383480-1485-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1406383480-1485-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2014 10:04 AM, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   arch/tile/kernel/setup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
> index 112abab..1af7d19 100644
> --- a/arch/tile/kernel/setup.c
> +++ b/arch/tile/kernel/setup.c
> @@ -1087,7 +1087,7 @@ static int __init setup_initramfs_file(char *str)
>   {
>   	if (str == NULL)
>   		return -EINVAL;
> -	strncpy(initramfs_file, str, sizeof(initramfs_file) - 1);
> +	strlcpy(initramfs_file, str, sizeof(initramfs_file));
>   	set_initramfs_file = 1;
>   
>   	return 0;

I'm inclined not to take this change, because it's not necessary.
The initramfs_file[] is already zero-filled by being in the BSS, and
this is a pretty obscure boot option, so it seems a bit more
maintainable to use a somewhat more standard string API call.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

