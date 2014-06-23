Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaFWGdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:33:44 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:43830 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaFWGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:33:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2194:2199:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6120:7652:7875:7903:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSB
X-HE-Tag: chair92_20251b758a73e
X-Filterd-Recvd-Size: 2626
Message-ID: <1403505219.18747.37.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 22 Jun 2014 23:33:39 -0700
In-Reply-To: <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 08:23 +0200, Mathias Krause wrote:
> On 23 June 2014 00:56, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
> >> [...] patch 2 adds some syntactical sugar for the most popular use
> >> case, by providing pr_<level> alike macros, namely pi_<level> for __init
> >> code and pe_<level> for __exit code. This hides the use of the marker
> >> macros behind the commonly known printing functions -- with just a
> >> single character changed.
> >>
> >> Patch 3 exemplarily changes all strings and format strings in
> >> arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
> >> few styling issues, though. But this already leads to ~1.7 kB of r/o
> >> data moved to the .init.rodata section, marking it for release after
> >> init.
> >>
> >> [...]
> >
> > I once proposed a similar thing.
> >
> > https://lkml.org/lkml/2009/7/21/421
> >
> > Matt Mackall replied
> >
> > https://lkml.org/lkml/2009/7/21/463
> >
> 
> Thanks for the pointers. Have you looked at patch 2 and 3? I don't
> think it makes the printk() case ugly. In fact, using pi_<level>()
> should be no less readable then pr_<level>, no?

I don't think it's particularly less readable, but I
do think using the plug-in mechanism might be a better
option as it would need no manual markings at all.

cheers, Joe

