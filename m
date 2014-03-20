Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaCTLGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:06:46 -0400
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:44119 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754940AbaCTLGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:06:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3870:3872:3873:4321:4605:5007:7652:8957:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knife30_579d6873fbe61
X-Filterd-Recvd-Size: 1871
Message-ID: <1395313600.7776.14.camel@joe-AO722>
Subject: Re: [PATCH 1/2] coding style: fix quoted string split across lines
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?C=E9dric?= Cabessa <ced@ryick.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 04:06:40 -0700
In-Reply-To: <1395266697-8699-2-git-send-email-ced@ryick.net>
References: <1395266697-8699-1-git-send-email-ced@ryick.net>
	 <1395266697-8699-2-git-send-email-ced@ryick.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 23:04 +0100, Cédric Cabessa wrote:
[]
> diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
[]
> @@ -178,8 +178,8 @@ static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
>  	}
>  
>  	pr_debug("       ");
> -	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) "
> -		 "wLength(%04X) ", cmd->bRequestType, cmd->bRequest,
> +	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) wLength(%04X) ",
> +		 cmd->bRequestType, cmd->bRequest,
>  		 cmd->wValue, cmd->wIndex, cmd->wLength);
>  	pr_debug("\n       ");

While you didn't change it, these uses are broken.

pr_debug always starts a new line so the continuations
attempted in this block don't work.

Likely this was originally converted from some non pr_debug
mechanism without an understanding of how pr_debug varies
from a normal printf.


