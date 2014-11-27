Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaK0PGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:06:23 -0500
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:60799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751151AbaK0PGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:06:21 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 10:06:21 EST
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3870:3871:3872:3873:3874:4250:4321:5007:6261:6690:7875:7903:10004:10400:10450:10455:10848:10967:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:14096:14097:19904:19999:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: error74_2cb1228cfe105
X-Filterd-Recvd-Size: 2559
Date: Thu, 27 Nov 2014 09:58:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, nsekhar@ti.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, Christoffer Dall <christoffer.dall@linaro.org>,
        jslaby@suse.cz,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: ftrace: Adds support for ftrace operations
Message-ID: <20141127095825.37f57197@gandalf.local.home>
In-Reply-To: <CACh+v5Phr-yA8c_bnooR8eLyEpmiMDwCGi2Oy8ArQayuRbeczA@mail.gmail.com>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
	<20141107115225.72bc6cbf@gandalf.local.home>
	<545CFAF4.8030104@traphandler.com>
	<CACh+v5MDFZj+NOPWdnMgNthn_DxL3nn=CZJ224vMh7hSf84o4Q@mail.gmail.com>
	<20141125182038.04497ec0@gandalf.local.home>
	<CACh+v5Phr-yA8c_bnooR8eLyEpmiMDwCGi2Oy8ArQayuRbeczA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 11:23:45 +0100
Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:

> 2014-11-26 0:20 GMT+01:00 Steven Rostedt <rostedt@goodmis.org>:
> > On Mon, 24 Nov 2014 10:59:24 +0100
> > Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
> >
> >> Hi Steve,
> >> did you get a chance of running your tests suite on real hardware with
> >> this patch? I'd be really interested in the results.
> >
> > Yes I finally got it working on my beaglebone white. It passed all the
> > tests that passed without it. Although I'm not sure this patch itself
> > was tested as I didn't have kprobes which might use it.
> >
> Thanks for testing it. At least it doesn't cause regression.
> What do you mean by not having krpobes which might use it ? Are you
> thinking of the kprobe optimization based on ftrace ?
> 

Yep. My tests use that. But as ARM doesn't have an mfentry where
functions probed by kprobes at the start are optimized with ftrace, my
tests wont test it.

I also didn't have kprobes enabled on this board. Is it fully supported
in ARM, and does kprobes use it there too?

-- Steve
