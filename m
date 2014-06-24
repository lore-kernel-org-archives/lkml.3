Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaFXVpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:45:17 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:53014 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbaFXVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:45:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3873:4321:4385:5007:6119:6120:7652:7903:8603:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13146:13161:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sail04_2d868e4d98008
X-Filterd-Recvd-Size: 2468
Message-ID: <1403646310.29061.61.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 24 Jun 2014 14:45:10 -0700
In-Reply-To: <CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	 <1403505219.18747.37.camel@joe-AO725> <87egyeqt03.fsf@rasmusvillemoes.dk>
	 <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	 <1403638620.29061.35.camel@joe-AO725>
	 <CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	 <1403641843.29061.51.camel@joe-AO725>
	 <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	 <1403643440.29061.56.camel@joe-AO725>
	 <CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 23:06 +0200, Mathias Krause wrote:
> On 24 June 2014 22:57, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2014-06-24 at 22:41 +0200, Mathias Krause wrote:
> >> And all of those strings should be in the .rodata section, now. But
> >> why you're asking?
> > Because now they will be duplicated in .rodata
> > and the __init section no?
> No. A string marked with __init_str() will only life in the
> .init.rodata section. No duplication.

Unless the same string is used in another bit
of code.  Then there's duplication.

> Having duplicated strings in .rodata and .init.rodata is also no
> problem as the latter will be freed.

They increase image size.


