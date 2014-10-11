Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaJKSfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:35:45 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:54388 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895AbaJKSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:35:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:4321:5007:7652:10004:10400:10848:11026:11658:11914:12043:12517:12519:12740:13069:13161:13229:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells49_4ef0d95d81b09
X-Filterd-Recvd-Size: 1578
Message-ID: <1413052541.22149.10.camel@joe-AO725>
Subject: Re: [PATCH] char: misc: use pr_err instead of printk
From: Joe Perches <joe@perches.com>
To: Rahul Bedarkar <rahulbedarkar89@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 11:35:41 -0700
In-Reply-To: <1413052311-2646-1-git-send-email-rahulbedarkar89@gmail.com>
References: <1413052311-2646-1-git-send-email-rahulbedarkar89@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-12 at 00:01 +0530, Rahul Bedarkar wrote:
[]
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
[]
> @@ -280,12 +280,12 @@ static int __init misc_init(void)
>  
>  	err = -EIO;
>  	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
> -		goto fail_printk;
> +		goto fail_pr_err;
>  	misc_class->devnode = misc_devnode;
>  	return 0;
>  
> -fail_printk:
> -	printk("unable to get major %d for misc devices\n", MISC_MAJOR);
> +fail_pr_err:
> +	pr_err("unable to get major %d for misc devices\n", MISC_MAJOR);
>  	class_destroy(misc_class);
>  fail_remove:
>  	remove_proc_entry("misc", NULL);

The printk is not relevant.
Maybe the label should be "fail_destroy:"

