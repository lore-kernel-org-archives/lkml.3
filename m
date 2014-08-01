Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaHAUNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:13:19 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:34325 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaHAUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:13:17 -0400
X-CheckPoint: {53DBF4DC-13-2100090A-C0000000}
Message-ID: <53DBF4C9.70604@tilera.com>
Date: Fri, 1 Aug 2014 16:12:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wang Sheng-Hui <shhuiw@gmail.com>
CC: Daniel Walter <dwalter@google.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
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

Thanks for the patch (this and the one for mpipe.c).  In general I'd rather
check the argument length and return a suitable error rather than using
strlcpy or strncpy to cause a corrupted partial string result.  I've done
this for the examples you pointed to (which I think is everything in arch/tile)
and I'll push those changes up.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

