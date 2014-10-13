Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaJMUeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:34:31 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:49162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752509AbaJMUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:34:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: baby44_44202d7f0ad3f
X-Filterd-Recvd-Size: 1580
Message-ID: <1413232466.1287.24.camel@joe-AO725>
Subject: Re: [PATCH 1/1 net-next] caif_usb: remove redundant memory message
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Mon, 13 Oct 2014 13:34:26 -0700
In-Reply-To: <1413231946-9914-1-git-send-email-fabf@skynet.be>
References: <1413231946-9914-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 22:25 +0200, Fabian Frederick wrote:
> Let MM subsystem display out of memory messages.
[]
> diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
[]
> @@ -87,10 +87,9 @@ static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
>  {
>  	struct cfusbl *this = kmalloc(sizeof(struct cfusbl), GFP_ATOMIC);
>  
> -	if (!this) {
> -		pr_warn("Out of memory\n");
> +	if (!this)
>  		return NULL;
> -	}
> +
>  	caif_assert(offsetof(struct cfusbl, layer) == 0);
>  
>  	memset(this, 0, sizeof(struct cflayer));

This bit should probably be:

	memset(&this->layer, 0, sizeof(this->layer));

or the allocation above should use kzalloc.


