Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbbAUNG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:06:27 -0500
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:45145 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752008AbbAUNGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:06:16 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4250:5007:6261:6742:7875:7903:8660:10004:10400:10848:10967:11026:11232:11658:11914:12050:12114:12438:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stove47_536a629065a51
X-Filterd-Recvd-Size: 2175
Date: Wed, 21 Jan 2015 08:06:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: Re: [PATCH 3.19-rc2 v14 0/7] arm: Implement
 arch_trigger_all_cpu_backtrace
Message-ID: <20150121080612.6569ab81@gandalf.local.home>
In-Reply-To: <54BF83C9.5060300@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
	<1421144818-14036-1-git-send-email-daniel.thompson@linaro.org>
	<54BE2D15.9080606@linaro.org>
	<54BEC04D.1050402@codeaurora.org>
	<54BF83C9.5060300@linaro.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 10:47:37 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:


> > With this patchset, is it possible to call sched_clock() from within NMI
> > context? I ask because the generic sched_clock() code is not NMI safe

That's not good. Better not run function tracing, as that could trace
functions in NMI context (I depend on that it does), and it uses
sched_clock() as the default clock.

-- Steve


> > today. We were planning on making it NMI safe by doing something similar
> > to what was done for ktime_get_mono_fast_ns() but we haven't gotten
> > around to it. Mostly because no architecture that uses generic
> > sched_clock() has support for NMIs right now.
> 
