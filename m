Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaJ2DGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:06:19 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:59975 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707AbaJ2DGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:06:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3873:3874:4321:5007:6261:6691:7808:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: room48_8e06b969d8738
X-Filterd-Recvd-Size: 2268
Message-ID: <1414551974.10912.16.camel@perches.com>
Subject: Re: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
From: Joe Perches <joe@perches.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Oct 2014 20:06:14 -0700
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D1825C@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
	 <1414392371.8884.2.camel@perches.com>
	 <1414531369.10912.14.camel@perches.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825C@CNBJMBX05.corpusers.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 10:42 +0800, Wang, Yalin wrote:
> > Use the inline function instead of directly indexing the array.
> > This allows some architectures with hardware instructions for bit reversals
> > to eliminate the array.
[]
> > On Sun, 2014-10-26 at 23:46 -0700, Joe Perches wrote:
> > > On Mon, 2014-10-27 at 14:37 +0800, Wang, Yalin wrote:
> > > > this change add CONFIG_HAVE_ARCH_BITREVERSE config option, so that
> > > > we can use arm/arm64 rbit instruction to do bitrev operation by
> > > > hardware.
[]
> I think the most safe way is change byte_rev_table[] to be satic,
> So that no driver can access it directly,
> The build error can remind the developer if they use byte_rev_table[]
> Directly .

You can do that with your later patch, but the
existing uses _must_ be converted first so you
don't break the build.



