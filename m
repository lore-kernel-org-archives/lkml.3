Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaFQA2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:28:23 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:51281 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751762AbaFQA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:28:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roll01_82e97b15ab232
X-Filterd-Recvd-Size: 1691
Message-ID: <1402964898.11561.2.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return
 statements
From: Joe Perches <joe@perches.com>
To: Anish Bhatt <anish@chelsio.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Mon, 16 Jun 2014 17:28:18 -0700
In-Reply-To: <1402961300-17985-1-git-send-email-anish@chelsio.com>
References: <1401728316.5770.9.camel@joe-AO725>
	 <1402961300-17985-1-git-send-email-anish@chelsio.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 16:28 -0700, Anish Bhatt wrote:
> This seems to ignore the ability to exit from void
> return functions via a `return;` in case of an error
> or similar. Any attempt to bail out generates warnings
> with checkpathch.pl Perhaps it should check for returns
> only at the end of the function ? If not, is there a
> suggested way to do this ? goto labels can't be directly
> used in place either

The only time checkpatch should bleat any message
is when there is a return; statement indented with
a single tab.
 
This form should be fine and not generate any
checkpatch warning.

void function(void)
{
	...

	if (err)
		return;

	...

}


If you want to use exit labels, I suggest you
use this form:

void function(void)
{

	...

	if (err)
		goto exit;

	...

exit:
	;
}


