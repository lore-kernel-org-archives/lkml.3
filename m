Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaCPQmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:42:47 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:57570 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753016AbaCPQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:42:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3743:3865:3866:3867:3868:3870:3871:3872:3873:3874:4184:4250:4321:5007:6117:6691:7652:7903:8828:9040:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13071:13095:13311:13357:14096:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: birds20_17f8986d58747
X-Filterd-Recvd-Size: 2657
Message-ID: <1394988163.5689.29.camel@joe-AO722>
Subject: Re: [PATCH 1/1] NTFS: Logging clean-up
From: Joe Perches <joe@perches.com>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Sun, 16 Mar 2014 09:42:43 -0700
In-Reply-To: <DB070619-215B-407E-827E-B9F383465DE2@tuxera.com>
References: <20140316132743.9e869dd95f2022572edc1745@skynet.be>
	 <3BC5D985-1160-4685-8656-A01350DECEBB@tuxera.com>
	 <1394986370.5689.17.camel@joe-AO722>
	 <DB070619-215B-407E-827E-B9F383465DE2@tuxera.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 16:27 +0000, Anton Altaparmakov wrote:
> Hi,

Hello all.

> On 16 Mar 2014, at 16:12, Joe Perches <joe@perches.com> wrote:

> > This changes prefixes from "NTFS-fs" to "ntfs"
> > and should be at a minimum mentioned in the
> > changelog.
> 
> As long as it says ntfs in the string so dmesg output can be
> "grep -i ntfs"-ed I am not fussed.

Nor I really, but mentioning what output changes occur
in the changelog is helpful.

> > Converting printk(KERN_DEBUG -> pr_debug will
> > not always emit that message now.  Now, only if
> > DEBUG is #defined or dynamic_debugging is enabled
> > for the build _and_ the message is specifically
> > enabled will the message be output.
> > 
> > So, the debugging output has been silenced by default.
> > 
> > That's not necessarily good.
> 
> No that is not good at all.  I didn't know about those pr_debug
> semantics so thank you for pointing them out.  That needs fixing
> otherwise we might as well not have the messages at all...  Being able
> to enable all ntfs debug messages using a insmod option or via /proc
> as is at the moment is a very valuable debugging too and I have
> scripts that use this so am not keen on this being changed at all.

> Fabian, can you please fix the issues pointed out by Joe and also
> please make sure you actually test it!

I think a good way to enable these by default is to add
#define DEBUG before any other #include (or any include
that includes printk.h actually), but there may be other
sections of code that are #ifdef DEBUG that would need
inspecting to make sure that more code isn't compiled in
than before.

cheers, Joe


