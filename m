Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaFBTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:39:19 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:42397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751996AbaFBTjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:39:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3351:3622:3653:3866:3867:3871:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tub47_8ab3c7a803f42
X-Filterd-Recvd-Size: 1695
Message-ID: <1401737951.7323.32.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: device_initcall is not the
 only __initcall substitute
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Mon, 02 Jun 2014 12:39:11 -0700
In-Reply-To: <1401729171-7298-1-git-send-email-fabf@skynet.be>
References: <1401729171-7298-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 19:12 +0200, Fabian Frederick wrote:
> This patch adds a link to init.h to find accurate initcall function
> to replace obsolete __initcall

maybe s/accurate/appropriate/

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4443,10 +4443,10 @@ sub process {
>  			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
>  		}
>  
> -# check for __initcall(), use device_initcall() explicitly please
> +# check for __initcall(), use device_initcall() explicitly or more accurate function please
>  		if ($line =~ /^.\s*__initcall\s*\(/) {
>  			WARN("USE_DEVICE_INITCALL",
> -			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
> +			     "please use device_initcall() or more accurate function instead of __initcall() (see include/linux/init.h)\n" . $herecurr);
>  		}



