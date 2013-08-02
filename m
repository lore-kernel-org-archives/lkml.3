Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3HBBNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:13:44 -0400
Received: from server506b.appriver.com ([50.56.144.14]:64865 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185Ab3HBBNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:13:43 -0400
X-Note-AR-ScanTimeLocal: 8/1/2013 8:13:42 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-20/SG:2 8/1/2013 8:12:57 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.985737 Source White
X-Signature-Violations: 0-0-0-3647-c
X-Note-419: 0 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/1/2013 8:13:37 PM
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH 2/2] aoe: use min() to simplify the code
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1375360134-20860-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 1 Aug 2013 21:13:40 -0400
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <5B6F37C8-CB08-4BA6-9AC9-D328711385F9@coraid.com>
References: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com> <1375360134-20860-2-git-send-email-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

I agree that we could do that.  I'm not sure it increases readability to put this much stuff on one line, though.  What is the motivation?

On Aug 1, 2013, at 8:28 AM, Andy Shevchenko wrote:

> min() incorporates condition in it. In our case we could do assignment and
> make a choice at once.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> drivers/block/aoe/aoedev.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> index db35ef6..92fadfa 100644
> --- a/drivers/block/aoe/aoedev.c
> +++ b/drivers/block/aoe/aoedev.c
> @@ -13,6 +13,7 @@
> #include <linux/kdev_t.h>
> #include <linux/moduleparam.h>
> #include <linux/string.h>
> +#include <linux/kernel.h>
> #include "aoe.h"
> 
> static void dummy_timer(ulong);
> @@ -248,10 +249,7 @@ user_req(char *s, size_t slen, struct aoedev *d)
> 	if (!d->gd)
> 		return 0;
> 	p = kbasename(d->gd->disk_name);
> -	lim = sizeof(d->gd->disk_name);
> -	lim -= p - d->gd->disk_name;
> -	if (slen < lim)
> -		lim = slen;
> +	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
> 
> 	return !strncmp(s, p, lim);
> }
> -- 
> 1.8.3.2
> 

-- 
  Ed Cashin
  ecashin@coraid.com


