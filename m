Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaLOV2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:28:38 -0500
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:44489 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745AbaLOV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:28:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4321:5007:6261:7903:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13161:13229:13255:13311:13357:13618:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bell55_8513ed0e5a235
X-Filterd-Recvd-Size: 1793
Message-ID: <1418678911.2674.21.camel@perches.com>
Subject: Re: [PATCH] Staging: wlan-ng: hfa384x_usb: fixed an 'else'
 statement coding style issue
From: Joe Perches <joe@perches.com>
To: Eduardo Barretto <edusbarretto@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Dec 2014 13:28:31 -0800
In-Reply-To: <20141215205355.GA5831@archer>
References: <1418608974-22509-1-git-send-email-edusbarretto@gmail.com>
	 <1418609490.2674.7.camel@perches.com> <20141215205355.GA5831@archer>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 18:53 -0200, Eduardo Barretto wrote:
> Thank you for the quick feedback. 
> It was my first patch to the kernel and I wanted to be sure it would get right to the community.
> I'll be making a version two with the consideration you brought me.

the code today is:

{
	switch (prdcode) {
	case [...]
		return 1;
	default:
		if (prdcode < 0x1000) {
			printk(msg1);
			return 1;
		else
			printk(msg2);
			return 0;
	}
	return 0;	/* avoid compiler noise */
}

I think this code does not needs changing.
I think more modern compilers don't even warn
when the last return 0; isn't there.

If it were to be changed, I'd probably write it like:

{
	switch (prdcode) {
	case [...]
		return 1;
	default:
		if (prdcode < 0x1000) {
			printk(msg1);
			return 1;
		}
		break;
	}

	printk(msg2);
	return 0;
}

but I wouldn't bother.

