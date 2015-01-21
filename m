Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbbAUQFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:05:33 -0500
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:33672 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754158AbbAUQFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:05:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2892:2910:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:6119:6261:6742:7875:7903:10004:10400:10450:10455:10462:10464:10848:11232:11658:11914:12050:12051:12517:12519:12740:13019:13069:13255:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ducks27_2f1aeabd32d53
X-Filterd-Recvd-Size: 3217
Message-ID: <1421856321.10574.13.camel@perches.com>
Subject: unclear ipv6 redirect message (was Re: [PATCH v3 2/3] mfd:
 lubbock_io: add lubbock_io board)
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        netdev <netdev@vger.kernel.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Lee Jones <lee.jones@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Date: Wed, 21 Jan 2015 08:05:21 -0800
In-Reply-To: <20150121094453.GO26493@n2100.arm.linux.org.uk>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
	 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
	 <20150119091705.GG21886@x1> <87ppaah9k5.fsf@free.fr>
	 <20150120102919.GP5767@x1> <20150120115658.GJ26493@n2100.arm.linux.org.uk>
	 <873874fuei.fsf@free.fr> <20150121094453.GO26493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding netdev)

On Wed, 2015-01-21 at 09:44 +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 21, 2015 at 08:46:29AM +0100, Robert Jarzmik wrote:
> > Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > 
> > > What I'd suggest (and always have done) is:
> > >
> > > 	dev_err(&pdev->dev, "couldn't request main irq%d: %d\n",
> > > 		irq, ret);
> > I like it, it's even more compact, I'll use it for next patch version.
> 
> BTW, this is an example why I have the policy of always ensuring that
> the kernel messages print sufficient diagnostics.  Right now, I have
> a problem - since I rebooted my firewall a few nights ago, I now get
> on one of my machines:
> 
>   rt6_redirect: source isn't a valid nexthop for redirect target
> 
> and it spews that for a few minutes every 26 hours or so.  No further
> information, and it leaves you wondering "well, what was the invalid
> next hop?  What was the source?"
> 
> Pretty much the only way to try and find out is to leave a tcpdump or
> wireshark running for 24 hours to try and get a dump - which is not
> that easy if you don't have lots of disk space.  So, right now, I have
> no way to diagnose the above.
> 
> If it printed that information, then I'd be able to see what the
> addresses were, and I'd probably be able to come up with a tcpdump
> filter which didn't involve logging all IPv6 traffic.
> 
> Kernel messages need to be smart.  If not, they might as well just be
> "The kernel encountered a problem. Abort, Retry or Fail?"
> 



