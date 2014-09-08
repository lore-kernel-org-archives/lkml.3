Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaIHNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:47:59 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:53088 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753492AbaIHNr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:47:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wire09_af31f44c8648
X-Filterd-Recvd-Size: 1495
Message-ID: <1410184074.12560.6.camel@joe-AO725>
Subject: Re: [PATCH] Staging: wlan-ng: Remove redundant break/goto
 statements in hfa384x_usb.c
From: Joe Perches <joe@perches.com>
To: Ilja Sidoroff <ilja.sidoroff@iki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2014 06:47:54 -0700
In-Reply-To: <1410180489-12140-1-git-send-email-ilja.sidoroff@iki.fi>
References: <1410180489-12140-1-git-send-email-ilja.sidoroff@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 15:48 +0300, Ilja Sidoroff wrote:
> This patch removes redundant goto or break statements in hfa384x_usb.c as found by checkpatch.pl
[]
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> @@ -3528,7 +3528,6 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
>  		netdev_warn(hw->wlandev->netdev, "Received frame on unsupported port=%d\n",
>  			    HFA384x_RXSTATUS_MACPORT_GET(
>  				    usbin->rxfrm.desc.status));
> -		goto done;
>  		break;
>  	}

Better still to change the other use of "goto done" to
"break" and then remove the done label altogether.


