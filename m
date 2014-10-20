Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaJTR3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:29:46 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:60223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750807AbaJTR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:29:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:6119:6261:7903:8603:10004:10400:10848:11232:11658:11914:12043:12050:12296:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: car59_1a57e9e61d15f
X-Filterd-Recvd-Size: 3242
Message-ID: <1413826179.19661.1.camel@perches.com>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Joe Perches <joe@perches.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: dedekind1@gmail.com, ezequiel.garcia@free-electrons.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 10:29:39 -0700
In-Reply-To: <54453E3B.2050809@codeaurora.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <543D304C.5000607@codeaurora.org> <1413297205.3269.11.camel@joe-AO725>
	 <1413299231.7906.101.camel@sauron.fi.intel.com>
	 <1413302724.3269.18.camel@joe-AO725>
	 <1413813074.7906.294.camel@sauron.fi.intel.com>
	 <54453E3B.2050809@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 19:54 +0300, Tanya Brokhman wrote:
> On 10/20/2014 4:51 PM, Artem Bityutskiy wrote:
> > On Tue, 2014-10-14 at 09:05 -0700, Joe Perches wrote:
> >> It's pretty trivial when all the lines are already
> >> being touched.
> >
> > OK, but then the same change should done in UBIFS, because it's
> > ubifs_msg() and so on macros are consistent with UBI macros. So I think
> > if this is done, then it is done separately for both UBI and UBIFS.
[]
> We have similar patch for ubifs as well, one that adds ubi number to all 
> ubifs messages. We just didn't get to sharing it yet.

[]

> I prefer not adding the "\n" to my patch unless Artem insists on it.

I tested a nearly completely automated conversion to use
functions ad %pV for ubifs_err/ubifs_warn while adding
'\n' to the uses. (converted ubifs_msg to ubifs_notice too)

It reduces the object size a couple percent.
(allyesconfig)

$ size fs/ubifs/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 335548	  66040	 138064	 539652	  83c04	fs/ubifs/built-in.o.new
 353362	  65912	 138000	 557274	  880da	fs/ubifs/built-in.o.old

It's not any real quantity of work to redo after you
post your patch.

There are a few defects today with unnecessary newlines
with ubifs_<level> uses.

$ git grep -P '\bubifs_\w+\s*.*\\n' 062a08d6ad56da23209083748ea5e0f1ab65a0e7 -- fs/ubifs/
062a08d6ad56da23209083748ea5e0f1ab65a0e7:fs/ubifs/debug.c:      ubifs_msg("first node at %d:%d\n", zbr1->lnum, zbr1->offs);
062a08d6ad56da23209083748ea5e0f1ab65a0e7:fs/ubifs/debug.c:      ubifs_msg("second node at %d:%d\n", zbr2->lnum, zbr2->offs);
062a08d6ad56da23209083748ea5e0f1ab65a0e7:fs/ubifs/debug.c:      ubifs_err("cannot create \"%s\" debugfs file or directory, error %d\n",
062a08d6ad56da23209083748ea5e0f1ab65a0e7:fs/ubifs/debug.c:      ubifs_err("cannot create \"%s\" debugfs file or directory, error %d\n",

Some with pr_<level> uses too.

