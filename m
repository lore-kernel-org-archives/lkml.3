Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaCCGqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:46:07 -0500
Received: from ni.piap.pl ([195.187.100.4]:56497 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaCCGqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:46:06 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net>
Date: Mon, 03 Mar 2014 07:46:03 +0100
In-Reply-To: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net> (Daeseok Youn's
	message of "Fri, 28 Feb 2014 16:36:03 +0900")
MIME-Version: 1.0
Message-ID: <m3bnxnpyok.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [PATCH 3/5 v2] Staging: cxt1e1: Fix line length over 80 characters in hwprobe.c
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140302 #7382666, check: 20140303 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daeseok Youn <daeseok.youn@gmail.com> writes:

> clean up checkpatch.pl warnings:
>  WARNING: Line length over 80 characters

This warning should be long gone IMHO. It does more harm than good.

>  		unsigned char *ucp = (unsigned char *) &hi->mfg_info.data;
>  
>  		pr_info("eeprom[00]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3), *(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
> +			*(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3),
> +			*(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
>  		pr_info("eeprom[08]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11), *(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
> +			*(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11),
> +			*(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
>  		pr_info("eeprom[16]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19), *(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
> +			*(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19),
> +			*(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
>  		pr_info("eeprom[24]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27), *(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
> +			*(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27),
> +			*(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
>  		pr_info("eeprom[32]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35), *(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
> +			*(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35),
> +			*(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
>  		pr_info("eeprom[40]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
> -				*(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43), *(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
> +			*(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43),
> +			*(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
>  	}

This one is probably an improvement, though... why not use some existing
*hex_dump*() instead?

> -		 * match with board's first found interface, otherwise this is first
> -		 * found
> +		 * match with board's first found interface, otherwise this is
> +		 * fisrt found
                   ^^^^^
I wonder what's your exact procedure for doing such changes :-)

>  #ifdef SBE_MAP_DEBUG
>  			pr_warning("%s: io remapped from phys %x to virt %x\n",
> -				   hi->devname, (u_int32_t) hi->addr[j], (u_int32_t) hi->addr_mapped[j]);
> +				   hi->devname, (u_int32_t) hi->addr[j],
> +				   (u_int32_t) hi->addr_mapped[j]);

This one is fine, too. The others, I wouldn't touch them.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
