Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3HBBEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:04:42 -0400
Received: from server506c.appriver.com ([50.56.144.127]:55083 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753037Ab3HBBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:04:40 -0400
X-Note-AR-ScanTimeLocal: 8/1/2013 8:04:39 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-104/SG:2 8/1/2013 8:04:32 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.985679 Source White
X-Signature-Violations: 0-0-0-3550-c
X-Note-419: 15.6001 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/1/2013 8:04:21 PM
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
Subject: Re: [PATCH 1/2] aoe: remove custom implementation of kbasename()
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 1 Aug 2013 21:04:36 -0400
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
Message-ID: <E4974451-025B-4694-89FE-20B310D6DFBF@coraid.com>
References: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK.  Thanks.

On Aug 1, 2013, at 8:28 AM, Andy Shevchenko wrote:

> In the kernel we have a nice helper that may be used here. This patch
> substitutes the custom implementation by the native function call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> drivers/block/aoe/aoedev.c | 9 +++------
> 1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> index 784c92e..db35ef6 100644
> --- a/drivers/block/aoe/aoedev.c
> +++ b/drivers/block/aoe/aoedev.c
> @@ -12,6 +12,7 @@
> #include <linux/bitmap.h>
> #include <linux/kdev_t.h>
> #include <linux/moduleparam.h>
> +#include <linux/string.h>
> #include "aoe.h"
> 
> static void dummy_timer(ulong);
> @@ -241,16 +242,12 @@ aoedev_downdev(struct aoedev *d)
> static int
> user_req(char *s, size_t slen, struct aoedev *d)
> {
> -	char *p;
> +	const char *p;
> 	size_t lim;
> 
> 	if (!d->gd)
> 		return 0;
> -	p = strrchr(d->gd->disk_name, '/');
> -	if (!p)
> -		p = d->gd->disk_name;
> -	else
> -		p += 1;
> +	p = kbasename(d->gd->disk_name);
> 	lim = sizeof(d->gd->disk_name);
> 	lim -= p - d->gd->disk_name;
> 	if (slen < lim)
> -- 
> 1.8.3.2
> 

-- 
  Ed Cashin
  ecashin@coraid.com


