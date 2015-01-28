Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbbA1VIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:08:46 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:50106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753956AbbA1Uy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:58 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2553:2559:2562:2693:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:4321:4385:5007:6119:6261:7875:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12043:12050:12438:12517:12519:12555:12663:12740:13069:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paper26_63c850a9ba203
X-Filterd-Recvd-Size: 2231
Date: Wed, 28 Jan 2015 07:38:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4 1/3] tracing: Add array printing helpers
Message-ID: <20150128073804.12bc56a5@gandalf.local.home>
In-Reply-To: <20150128122403.GA1542@e104805>
References: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
	<1422274311-19738-2-git-send-email-javi.merino@arm.com>
	<20150127223557.407f3a13@gandalf.local.home>
	<20150128112609.GA2938@e104805>
	<20150128122403.GA1542@e104805>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 12:24:03 +0000
Javi Merino <javi.merino@arm.com> wrote:

> > > el_size should not be based on bits, it should be based on bytes. I
> > > passed in "sizeof()" which doesn't work with bits.
> 
> Ugh.  If you use sizeof() in print_array() then trace-cmd won't be
> able to parse it since it doesn't have an implementation of sizeof().
> 
>   [thermal_power_allocator:thermal_power_allocator] function sizeof not defined
>   Error: expected type 5 but read 0
> *** Error in `./trace-cmd': double free or corruption (fasttop): 0x0000000000e04980 ***
> 
> Implementing a fully functional sizeof() in trace-cmd will be a huge
> beast, I guess you will have to limit it to only some types.

Well it shouldn't crash, because people will be using things like
sizeof(). Just default it to 4 or 8 (word length).

We can work on a sizeof routine later. I have ideas on how to do it. Or
at least make it work for the common cases.

-- Steve

> 
> > > Please update to "el_size < 1 || el_size > 8".
> > > 
> > > and adjust the rest accordingly.
> > 
> > Done, I'm testing it now.  I'll send a v5 later today.
> > 
> > Cheers,
> > Javi

