Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaAaAzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:55:09 -0500
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:58398 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753515AbaAaAzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:55:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:421:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6120:7576:7652:9038:10004:10400:10848:11026:11232:11658:11914:12043:12219:12438:12517:12519:12740:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: offer62_66613764a4222
X-Filterd-Recvd-Size: 1583
Message-ID: <1391129701.2422.75.camel@joe-AO722>
Subject: Re: [RFC PATCH] net: core: move core networking work to power
 efficient workqueue
From: Joe Perches <joe@perches.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 30 Jan 2014 16:55:01 -0800
In-Reply-To: <52EAF2E5.8090403@meshcoding.com>
References: <1391128402-10725-1-git-send-email-zoran.markovic@linaro.org>
	 <52EAF2E5.8090403@meshcoding.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 01:48 +0100, Antonio Quartulli wrote:
> On 31/01/14 01:33, Zoran Markovic wrote:
> > From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> [...]
> 
> > -		schedule_delayed_work(&linkwatch_work, delay);
> > +		queue_delayed_work(system_power_efficient_wq,
> > +			&linkwatch_work, delay);
> 
> before talking about technical details, here and in other spots of this
> patch the alignment is wrong. I think checkpatch should have said
> something about it. The first parameter on the new line should be
> aligned up to the column after the opening parenthesis.

Using "scripts/checkpatch.pl --strict" would emit an
alignment message, otherwise not.

