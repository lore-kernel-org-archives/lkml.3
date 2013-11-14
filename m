Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3KNNkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:40:00 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:49030 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752932Ab3KNNjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:39:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2693:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:3873:3874:4250:4321:4470:4605:5007:7652:8792:9108:9121:10011:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: heart26_3908571c8650d
X-Filterd-Recvd-Size: 2105
Message-ID: <1384436392.15774.2.camel@joe-AO722>
Subject: Re: [PATCH] I2C: busses: Do not print error message in syslog if no
 ACK received
From: Joe Perches <joe@perches.com>
To: Marek Vasut <marex@denx.de>
Cc: Andreas Werner <wernerandy@gmx.de>, wsa@the-dreams.de, jacmet@sunsite.dk,
        baohua.song@csr.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Nov 2013 05:39:52 -0800
In-Reply-To: <201311132024.06853.marex@denx.de>
References: <1384278336-3694-1-git-send-email-wernerandy@gmx.de>
	 <201311121933.41038.marex@denx.de>
	 <20131113182415.GA1458@thinkpad.fritz.box>
	 <201311132024.06853.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-13 at 20:24 +0100, Marek Vasut wrote:
> > On Tue, Nov 12, 2013 at 07:33:40PM +0100, Marek Vasut wrote:
> > > > > That is because if you look at the only caller of this function,
> > > > > which is pch_i2c_wait_for_check_xfer(), you will see that at the
> > > > > only place where pch_i2c_getack() is called there is already
> > > > > pch_dbg():
> > > > > 
> > > > > 369         if (pch_i2c_getack(adap)) {
> > > > > 370                 pch_dbg(adap, "Receive NACK for slave address"
> > > > > 371                         "setting\n");
> > > > > 372                 return -EIO;
> > > > > 373         }
> > 
> > Sorry i misunderstood that. You are absolutly right, thats the best
> > solution for that. Remove the pch_err at getack so that only the pch_dbg
> > get printed where getack is called. This should be enough information.
> 
> No problem ;-)

If this is the approach taken, please coalesce the format.
As is there's a missing space between address and setting.
This should be:

		pch_dbg(adap, "Received NACK for slave address setting\n");


