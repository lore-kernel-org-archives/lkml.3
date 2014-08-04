Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaHDP0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:26:41 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:34210 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751125AbaHDP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:26:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes48_913f2b077165e
X-Filterd-Recvd-Size: 1876
Message-ID: <1407165996.16152.75.camel@joe-AO725>
Subject: Re: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
From: Joe Perches <joe@perches.com>
To: Dotan Barak <dotanb@mellanox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Aug 2014 08:26:36 -0700
In-Reply-To: <3b44a1bc344f40feb7c8119a4b102494@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407159342.16152.63.camel@joe-AO725>
	 <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407162439.16152.67.camel@joe-AO725>
	 <f95137f9228a4f08ba391f9640237d28@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407165075.16152.70.camel@joe-AO725>
	 <3b44a1bc344f40feb7c8119a4b102494@DB3PR05MB380.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 15:19 +0000, Dotan Barak wrote:
> In our code (I take it as an example), we used  MLX5_DECLARE_DOORBELL_LOCK,
> So I guess that the regular expression that you mentioned will fail on it
> (because the "_" is not allowed to be repeated).
> 
> So, I would change it a little bit to allow people to use underscore as a word separator.
[]
> > Maybe:
> > 
> > (?:$Storage\s+)(?:[A-Z_][A-Z0-9]+_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,2}

What I suggested should allow any of:

	DECLARE_FOO
	_FOO_DEFINE_BAR
	FOO_BAR_DEFINE_BAZ
	FOO_BAR_DECLARE_BAZ_QUX

where FOO/BAR/BAZ/QUX can also have digits

