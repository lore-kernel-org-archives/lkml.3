Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaBXWbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:31:42 -0500
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:53590 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752664AbaBXWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:31:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: voice89_e791e4da2700
X-Filterd-Recvd-Size: 2470
Message-ID: <1393281098.11020.82.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
From: Joe Perches <joe@perches.com>
To: Tom Rini <trini@ti.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Feb 2014 14:31:38 -0800
In-Reply-To: <530BC5A4.4060803@ti.com>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
	 <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>
	 <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>
	 <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com>
	 <1393279691.11020.69.camel@joe-AO722> <530BC5A4.4060803@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 17:20 -0500, Tom Rini wrote:
> On 02/24/2014 05:08 PM, Joe Perches wrote:
> > On Mon, 2014-02-24 at 17:04 -0500, Tom Rini wrote:
> >> I've got this modified to a CHK and only for non-file usage.  Anything
> >> else we want to talk about before I repost?
> > 
> > Probably not, but I'm still not convinced it's useful.
> > 
> > Have you found a case where it's currently specified
> > but not useful?
> 
> Well, U-Boot and the kernel both share the dubious to incorrect __packed
> horror of cros_ec things (see include/linux/mfd/cros_ec_commands.h).

Are the __packed entries in cros_ec dubious?

Maybe the ones that don't seem to need them
because the are naturally 32 bit aligned, but
the others that are u16 aligned probably _do_
need __packed.

> If this is really not seen as useful for the kernel, that's fine, I'll
> drop it.  I mainly did this for U-Boot where we do want a bit more loud
> screaming going on when people add __packed to make sure it's for a good
> reason.  Wanted to be a good neighbor so to speak and see if upstream
> wants it too.

I don't mind keeping checkpatch compatible with U-Boot
requirements, but probably not on by default.

Maybe there would be some "UBOOT-<foo>" type specific entries
that could be default off but enabled with some wildcard or
a .checkpatch.conf specific file for U-Boot.


