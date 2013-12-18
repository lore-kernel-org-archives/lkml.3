Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LRFm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:42:57 -0500
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:60605 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241Ab3LRFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:42:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:3872:3874:4321:5007:7652:8660:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pets79_361d9c35db513
X-Filterd-Recvd-Size: 1582
Message-ID: <1387345370.13593.10.camel@joe-AO722>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Date: Tue, 17 Dec 2013 21:42:50 -0800
In-Reply-To: <20131217182733.GA16202@www.outflux.net>
References: <20131217182733.GA16202@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 10:27 -0800, Kees Cook wrote:
> This makes sure format strings cannot leak into the printk call via the
> constructed buffer.
[]
> diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
[]
> @@ -171,7 +171,7 @@ static int esas2r_log_master(const long level,
>  		if (strlen(event_buffer) < buflen)
>  			strcat(buffer, "\n");
>  
> -		printk(event_buffer);
> +		printk("%s", event_buffer);

It's probably better to remove the

		if (strlen(event_buffer) < buflen)
			strcat(buffer, "\n");

and use

	printk("%s\n", event_buffer);

so that the output is always newline terminated.


