Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CKRpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:45:06 -0400
Received: from server506f.appriver.com ([50.56.144.36]:59552 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149Ab3CKRpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:45:01 -0400
X-Note-AR-ScanTimeLocal: 3/11/2013 12:45:00 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] aoe: replace kmalloc and then memcpy with kmemdup
Thread-Topic: [PATCH] aoe: replace kmalloc and then memcpy with kmemdup
Thread-Index: AQHOHkn6swTm7TGDIkqlIfzfKqsU8ZihF36A
Date: Mon, 11 Mar 2013 17:44:49 +0000
Message-ID: <DFE3B626E00A3346A98511AD95B78358087FAE@DAGN05A-E6.exg6.exghost.com>
References: <1363000607-8173-1-git-send-email-mihneadb@gmail.com>
In-Reply-To: <1363000607-8173-1-git-send-email-mihneadb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [72.32.31.161]
x-rerouted-by-exchange: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <147313B90C0E5E4CA84FAEC15AED4B20@exg6.exghost.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK, thanks.

On Mar 11, 2013, at 7:16 AM, Mihnea Dobrescu-Balaur wrote:

> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
> ---
> drivers/block/aoe/aoechr.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
> index 42e67ad..ab41be6 100644
> --- a/drivers/block/aoe/aoechr.c
> +++ b/drivers/block/aoe/aoechr.c
> @@ -139,13 +139,12 @@ bail:		spin_unlock_irqrestore(&emsgs_lock, flags);
> 		return;
> 	}
> 
> -	mp = kmalloc(n, GFP_ATOMIC);
> +	mp = kmemdup(msg, n, GFP_ATOMIC);
> 	if (mp == NULL) {
> 		printk(KERN_ERR "aoe: allocation failure, len=%ld\n", n);
> 		goto bail;
> 	}
> 
> -	memcpy(mp, msg, n);
> 	em->msg = mp;
> 	em->flags |= EMFL_VALID;
> 	em->len = n;
> -- 
> 1.7.10.4
> 

-- 
  Ed Cashin
  ecashin@coraid.com


