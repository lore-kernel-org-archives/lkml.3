Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968217Ab3DRKqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:46:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967157Ab3DRKqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:46:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Date: Thu, 18 Apr 2013 12:46:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181246.03357.arnd@arndb.de>
X-Provags-ID: V02:K0:+lnzb1lUr2DnTREb8BOhwVKPiIEsvfDhA1UQp9xJ7VD
 QQRBmyRWvBwxAJXwhq4QsBLOh5as7qkyt08Zkk63LcQqsUEIf9
 ZAAEXTe8FRqoJh1xIkfYBVlvyQXpBhNsYKXtqB/jwyOz30mXHm
 JWOb9AKK0/sXGpZlyAarc9zOyKbY3qDHF0jxK6t3sg+8lSLQsy
 pdMuQIgj61yjVPcQ9qlAIDuasWYVHelvQeC66d7Oli3AtM8may
 kv83jSR4RfcU7TdoJaHm2eIuawoIJqC02hoo4STX38jmUgZAKE
 HZU7coa5RwMLxyBpIyvxVl3ORGCE+z+iTK0dcylk0L9aXm+804
 AUcCZjBBMOCUTdLCzr/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> The current implementation of the DMA40's local MAX() macro evaluates
> its arguments more times than is necessary. This patch strips it
> optimises it to only evaluate what's appropriate.

No, it does not.

> index b21a8a3..7b451b2 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -53,7 +53,7 @@
>  #define D40_ALLOC_PHY          BIT(30)
>  #define D40_ALLOC_LOG_FREE     BIT(0)
>  
> -#define MAX(a, b) (((a) < (b)) ? (b) : (a))
> +#define MAX(a, b) ((a > b) ? a : b)

This just makes the macro worse in case you pass a complex expression
in, which can now have additional unwanted effects. Just drop this patch.

	Arnd
