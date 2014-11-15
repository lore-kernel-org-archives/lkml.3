Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaKOPb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 10:31:28 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56941 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaKOPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 10:31:27 -0500
Message-ID: <546771CD.3020307@lwfinger.net>
Date: Sat, 15 Nov 2014 09:31:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christian Resell <christian.resell@gmail.com>, devel@driverdev.osuosl.org
CC: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        marcus.farkas@finitebox.com, dan.carpenter@oracle.com,
        sudipm.mukherjee@gmail.com, paul.gortmaker@windriver.com,
        tapaswenipathak@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: fix coding style warning
References: <20141115142535.GB15904@Kosekroken.jensen.com>
In-Reply-To: <20141115142535.GB15904@Kosekroken.jensen.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2014 08:25 AM, Christian Resell wrote:
> Simple style fix ("else is not generally useful after a break or return").
> For the eudyptula challenge (http://eudyptula-challenge.org/).
>
> Signed-off-by: Christian F. Resell <christian.resell@gmail.com>
> ---

This patch leads to the following build warnings:

   CC [M]  drivers/staging/rtl8712/rtl871x_security.o
In file included from drivers/staging/rtl8712/osdep_service.h:43:0,
                  from drivers/staging/rtl8712/rtl871x_security.c:45:
drivers/staging/rtl8712/rtl871x_security.c: In function ‘crc32_init’:
drivers/staging/rtl8712/basic_types.h:35:14: warning: ISO C90 forbids mixed 
declarations and code [-Wdeclaration-after-statement]
  #define sint signed int
               ^
drivers/staging/rtl8712/rtl871x_security.c:129:2: note: in expansion of macro ‘sint’
   sint i, j;
   ^
The previous code had braces around the code in question. Either you need to 
leave those braces, or you need to move the declarations.

Please compile test your patches!

Larry

> diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
> index c653ad6..cc3a446 100644
> --- a/drivers/staging/rtl8712/rtl871x_security.c
> +++ b/drivers/staging/rtl8712/rtl871x_security.c
> @@ -126,26 +126,24 @@ static void crc32_init(void)
>   {
>   	if (bcrc32initialized == 1)
>   		return;
> -	else {
> -		sint i, j;
> -		u32 c;
> -		u8 *p = (u8 *)&c, *p1;
> -		u8 k;
> -
> -		c = 0x12340000;
> -		for (i = 0; i < 256; ++i) {
> -			k = crc32_reverseBit((u8)i);
> -			for (c = ((u32)k) << 24, j = 8; j > 0; --j)
> -				c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY :
> -				    (c << 1);
> -			p1 = (u8 *)&crc32_table[i];
> -			p1[0] = crc32_reverseBit(p[3]);
> -			p1[1] = crc32_reverseBit(p[2]);
> -			p1[2] = crc32_reverseBit(p[1]);
> -			p1[3] = crc32_reverseBit(p[0]);
> -		}
> -		bcrc32initialized = 1;
> +	sint i, j;
> +	u32 c;
> +	u8 *p = (u8 *)&c, *p1;
> +	u8 k;
> +
> +	c = 0x12340000;
> +	for (i = 0; i < 256; ++i) {
> +		k = crc32_reverseBit((u8)i);
> +		for (c = ((u32)k) << 24, j = 8; j > 0; --j)
> +			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY :
> +				(c << 1);
> +		p1 = (u8 *)&crc32_table[i];
> +		p1[0] = crc32_reverseBit(p[3]);
> +		p1[1] = crc32_reverseBit(p[2]);
> +		p1[2] = crc32_reverseBit(p[1]);
> +		p1[3] = crc32_reverseBit(p[0]);
>   	}
> +	bcrc32initialized = 1;
>   }
>
>   static u32 getcrc32(u8 *buf, u32 len)
>

