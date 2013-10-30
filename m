Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3J3SML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:12:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3J3SMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:12:10 -0400
Message-ID: <52714BF8.5040008@infradead.org>
Date: Wed, 30 Oct 2013 11:12:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] Fix build without CONFIG_INPUT_LEDS [Was: mmotm 2013-10-29-16-22
 uploaded (input)]
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com> <52706790.9090602@infradead.org> <20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
In-Reply-To: <20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/13 04:46, Samuel Thibault wrote:
> Randy Dunlap, le Tue 29 Oct 2013 18:57:36 -0700, a écrit :
>> arc_ps2.c:(.text+0x500): multiple definition of `input_led_connect'
> 
> D'oh.  I indeed hadn't tested the inlines, sorry about this.
> 
> Andrew, could you add the following patch on top of
> input-route-kbd-leds-through-the-generic-leds-layer.patch
> or perhaps rather fold into it?
> 
> Samuel
> 
> 
> 
> Really mark inlines as static inlines, so they are not defined multiple
> times.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> 
> --- include/linux/input.h.orig	2013-10-30 12:42:41.169038670 +0100
> +++ include/linux/input.h	2013-10-30 12:42:42.908987157 +0100
> @@ -540,12 +540,12 @@
>  
>  #else
>  
> -int input_led_connect(struct input_dev *dev)
> +static inline int input_led_connect(struct input_dev *dev)
>  {
>  	return 0;
>  }
>  
> -void input_led_disconnect(struct input_dev *dev)
> +static inline void input_led_disconnect(struct input_dev *dev)
>  {
>  }
>  
> --


-- 
~Randy
