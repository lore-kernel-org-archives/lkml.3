Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaGNKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:43:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaGNKm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:42:59 -0400
Date: Mon, 14 Jul 2014 12:42:55 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/udf: re-use hex_asc_upper_{hi,lo} macros
Message-ID: <20140714104255.GE30550@quack.suse.cz>
References: <1404909330-5955-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404909330-5955-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-07-14 15:35:30, Andy Shevchenko wrote:
> This patch cleans up udf_translate_to_linux() a bit by using globally defined
> macros instead of custom code.
> 
> We can use sprintf(buf, "%04X", ...) there as well, but this one faster.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
  Thanks. I've merged the patch.

								Honza

> ---
>  fs/udf/unicode.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index 44b815e..afd470e 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -412,7 +412,6 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName,
>  	int extIndex = 0, newExtIndex = 0, hasExt = 0;
>  	unsigned short valueCRC;
>  	uint8_t curr;
> -	const uint8_t hexChar[] = "0123456789ABCDEF";
>  
>  	if (udfName[0] == '.' &&
>  	    (udfLen == 1 || (udfLen == 2 && udfName[1] == '.'))) {
> @@ -477,10 +476,10 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName,
>  			newIndex = 250;
>  		newName[newIndex++] = CRC_MARK;
>  		valueCRC = crc_itu_t(0, fidName, fidNameLen);
> -		newName[newIndex++] = hexChar[(valueCRC & 0xf000) >> 12];
> -		newName[newIndex++] = hexChar[(valueCRC & 0x0f00) >> 8];
> -		newName[newIndex++] = hexChar[(valueCRC & 0x00f0) >> 4];
> -		newName[newIndex++] = hexChar[(valueCRC & 0x000f)];
> +		newName[newIndex++] = hex_asc_upper_hi(valueCRC >> 8);
> +		newName[newIndex++] = hex_asc_upper_lo(valueCRC >> 8);
> +		newName[newIndex++] = hex_asc_upper_hi(valueCRC);
> +		newName[newIndex++] = hex_asc_upper_lo(valueCRC);
>  
>  		if (hasExt) {
>  			newName[newIndex++] = EXT_MARK;
> -- 
> 2.0.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
