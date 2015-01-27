Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbbA0RsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:48:22 -0500
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:47111 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758153AbbA0RsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:48:21 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2840:2892:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4389:5007:6119:6261:7875:7903:10004:10400:10848:10967:11232:11658:11914:12050:12219:12517:12519:12679:12740:13069:13311:13357:13869:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brick73_82c26a487e340
X-Filterd-Recvd-Size: 2630
Date: Tue, 27 Jan 2015 12:48:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127124817.608db508@gandalf.local.home>
In-Reply-To: <54C7CD1C.1060601@ahsoftware.de>
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
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 18:38:36 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> Anyway, I like(d) Linux because it didn't had a splash screen and used 
> to spit out all types of information on the screen where it could be 
> easily seen or found (in contrast other OS which try to hide all 
> technical details from users).

Yes, I like those days too, but as you say, times are changing, and we
must adapt.

> 
> Of course, times are changing, including the amount of stuff printed on 
> screen. But I still find it much much easier to grep on the output of 
> dmesg than to search through thousands files in sysfs. Even if that can 
> be done with grep too (kind of). But it's much more complicated because 
> grep doesn't connect the file name with the content, so you need more 
> complicated stuff to combine both in order to search for and find 
> something in sysfs.

Come on, it's not that more complex. If you know the name of the file,
just do:

find /sys -print -name <name> -exec cat {} \;

And you'll get the data you want.

Basically, what you are saying is "printk is more convenient for me and
I do not care about the other cases that make much more sense with
sysfs". The kernel does not work that way.

-- Steve
