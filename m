Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967746Ab3E3HJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:09:58 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34751 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967694Ab3E3HJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:09:48 -0400
X-Auth-Info: OZKifq6bWXZneJBlKahCLeULRV3zEuHK17vesllbCFA=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: math-emu: unsigned issue, 'unsigned long' will never be less than zero.
References: <51A6F0C6.9050806@asianux.com>
X-Yow: Is it clean in other dimensions?
Date: Thu, 30 May 2013 09:09:38 +0200
In-Reply-To: <51A6F0C6.9050806@asianux.com> (Chen Gang's message of "Thu, 30
	May 2013 14:25:10 +0800")
Message-ID: <m2a9ndndu5.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

> 'oldmant.m32[1]' is 'unsigned long' which never '< 0', and the original
> author wanted to check the highest bit whether set.
>
> So need type cast form 'unsigned long' to 'long'.

Better to make the bit test explicit, since it is not a sign bit.

> diff --git a/arch/m68k/math-emu/fp_arith.c b/arch/m68k/math-emu/fp_arith.c
> index 08f286d..ef013c5 100644
> --- a/arch/m68k/math-emu/fp_arith.c
> +++ b/arch/m68k/math-emu/fp_arith.c
> @@ -519,7 +519,7 @@ static void fp_roundint(struct fp_ext *dest, int mode)
>  				return;
>  			break;
>  		case 0x401e:
> -			if (!(oldmant.m32[1] >= 0))
> +			if (!((long)oldmant.m32[1] >= 0))

			if (oldmant.m32[1] & 0x80000000)

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
