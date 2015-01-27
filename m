Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbbA0SVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:21:53 -0500
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:35210 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759080AbbA0SVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:21:52 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2691:2693:2731:2840:2892:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4389:5007:6119:6261:7875:7904:9040:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13149:13184:13215:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wax55_845e2d058235c
X-Filterd-Recvd-Size: 2943
Date: Tue, 27 Jan 2015 13:21:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127132148.365ef397@gandalf.local.home>
In-Reply-To: <54C7D549.3070705@ahsoftware.de>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
	<CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
	<54C77E69.7050600@ahsoftware.de>
	<20150127120855.GA9254@pd.tnic>
	<54C7816A.8050800@ahsoftware.de>
	<54C78524.3070901@nod.at>
	<54C7881F.6020501@ahsoftware.de>
	<20150127142120.GA3351@pd.tnic>
	<54C7C2EC.7010605@ahsoftware.de>
	<20150127172415.GC25043@home.goodmis.org>
	<54C7CD1C.1060601@ahsoftware.de>
	<20150127124817.608db508@gandalf.local.home>
	<54C7D549.3070705@ahsoftware.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 19:13:29 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> > Basically, what you are saying is "printk is more convenient for me and
> > I do not care about the other cases that make much more sense with
> > sysfs". The kernel does not work that way.
> 
> No. First I don't know the name of one of the thousands file in sysfs, 
> just like I don't know all the possible kernel messages.

But as Richard mentioned, it should be documented in Documentation/ABI,
and the information you want should be right there. Once you know it,
you will know it for good.

> 
> And second I still believe that KISS is the right way and frameworks 
> aren't the right choice for everything.

But having tools parse dmesg is not KISS. It's backwards. /sys
filesystem is really simple to use. It's not that difficult. And it was
created for just this purpose!

> 
> But because I still don't refuse to learn, I will attach the output of
> 
> find /sys -type f -print -exec cat {} \;
> 
> to future bug reports instead of the output of dmesg.
> 

That is completely different. dmesg will contain back traces which are
not in /sys filesystem, nor do they belong there. dmesg also shows
order of events, which may be needed in debugging, again, sysfs is
about properties and states of devices. How would sysfs be used for
debugging?

You want to add a way to tell a property of a device. That is *exactly*
what sysfs was made for. Not dmesg.

-- Steve

