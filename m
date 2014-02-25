Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaBYJ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:59:34 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:37449 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751611AbaBYJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:59:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:4037:4321:5007:7652:7903:8957:9010:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes24_355aa11147732
X-Filterd-Recvd-Size: 2003
Message-ID: <1393322365.8716.3.camel@joe-AO722>
Subject: Re: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
From: Joe Perches <joe@perches.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Monam Agarwal <monamagarwal123@gmail.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 25 Feb 2014 01:59:25 -0800
In-Reply-To: <530C666B.6080900@mev.co.uk>
References: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
	 <530C666B.6080900@mev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 09:46 +0000, Ian Abbott wrote:
> On 2014-02-24 16:49, Monam Agarwal wrote:
[]
> > diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
[]
> > @@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
> >   	async->cmd.data = NULL;
> >   	/* load channel/gain list */
> >   	async->cmd.chanlist = memdup_user(user_chanlist,
> > -					  async->cmd.chanlist_len * sizeof(int));
> > +					  async->cmd.chanlist_len
> > +					  * sizeof(int));
> 
> The `*` operator should go at the end of the line according to the 
> CodingStyle.

I don't believe there's a CodingStyle guide for this.

Another way to do this is to move the memdup_user to
a separate line like:

	async->cmd_chanlist =
		memdup_user(user_chanlist,
			    async->cmd.chanlist_len * sizeof(int));

but I'm not bothered by the existing > 80 column use.

