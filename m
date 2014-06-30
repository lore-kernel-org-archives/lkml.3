Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaF3R2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:28:01 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33268 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaF3R16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:27:58 -0400
X-Auth-Info: w7zUiNjkHI09yRSn1+neSzpkq8zxskXFSKEVOgI9mZ4=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes q40_irq_startup to return -ENXIO
References: <1404097610-5739-1-git-send-email-xerofoify@gmail.com>
X-Yow: Yow!!  It's LIBERACE and TUESDAY WELD!!  High on a HILL... driving a
 LITTLE CAR...  I wanna be in that LITTLE CAR, too!!  I wanna drive off
 with LIBBY and TUESDAY!
Date: Mon, 30 Jun 2014 19:27:55 +0200
In-Reply-To: <1404097610-5739-1-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Sun, 29 Jun 2014 23:06:50 -0400")
Message-ID: <871tu6ux2c.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> writes:

> Fixes q40_irq_startup to return -ENXIO for cases 11-13 in the switch
> statement of this function to handle these failure cases.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/m68k/q40/q40ints.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
> index 513f9bb..9dfa1ea 100644
> --- a/arch/m68k/q40/q40ints.c
> +++ b/arch/m68k/q40/q40ints.c
> @@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
>  	case 1: case 2: case 8: case 9:
>  	case 11: case 12: case 13:
>  		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
> -		/* FIXME return -ENXIO; */
> +		return -ENXIO;

There must be more to it, given the FIXME.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
