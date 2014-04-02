Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbaDBXrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:47:18 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:52957 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161092AbaDBXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:47:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:4321:4605:5007:6120:7652:9121:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13146:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCac
X-HE-Tag: bear90_3ef1250c6ac24
X-Filterd-Recvd-Size: 2026
Message-ID: <1396482431.32040.21.camel@joe-AO722>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Date: Wed, 02 Apr 2014 16:47:11 -0700
In-Reply-To: <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	 <20140402221212.GD16570@mguzik.redhat.com>
	 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	 <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 16:42 -0700, Linus Torvalds wrote:
> On Wed, Apr 2, 2014 at 4:28 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Could be done per-fd: put a struct ratelimit_state into struct
> > devkmsg_user.
> 
> Yeah, what Andrew said.

The default ratelimit state values are pretty low
and may need to be exposed or increased here.

include/linux/ratelimit.h:#define DEFAULT_RATELIMIT_INTERVAL    (5 * HZ)
include/linux/ratelimit.h:#define DEFAULT_RATELIMIT_BURST               10


