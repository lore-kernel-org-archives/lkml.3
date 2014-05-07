Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaEGShL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:37:11 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:58670 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751481AbaEGShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:37:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2692:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4043:4250:4321:5007:6119:6691:7652:7903:9040:10004:10400:10848:10967:11232:11658:11914:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate06_782cfba357e1d
X-Filterd-Recvd-Size: 3326
Message-ID: <1399487824.2911.28.camel@joe-AO725>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Streetman <ddstreet@ieee.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 07 May 2014 11:37:04 -0700
In-Reply-To: <20140507141956.4eb6ff8d@gandalf.local.home>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	 <1399300985-11137-1-git-send-email-ddstreet@ieee.org>
	 <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
	 <CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
	 <20140506174445.b64dffb78d0676b48fa68eea@skynet.be>
	 <CALZtONBADrb_yCPqCAUfw1ei9sYxw_-MopPko3dcfas2mqsVZg@mail.gmail.com>
	 <20140507103512.5b3f7928@gandalf.local.home>
	 <1399486238.2911.20.camel@joe-AO725>
	 <20140507141956.4eb6ff8d@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 14:19 -0400, Steven Rostedt wrote:
> On Wed, 07 May 2014 11:10:38 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2014-05-07 at 10:35 -0400, Steven Rostedt wrote:
> > > On Wed, 7 May 2014 10:21:28 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
> > 
> > > > It would be even better if the note could clarify that sometimes it is
> > > > ok to use printk(KERN_DEBUG
> > > 
> > > Exactly. I think it's rather stupid to have to do a #define DEBUG to
> > > have pr_debug() print in general.
> > > 
> > > I see no reason to have pr_debug() be anything different than the other
> > > pr_*() functions.
> > 
> > pr_debug is meant to be disabled and have _no_ runtime
> > effect unless DEBUG is #defined.
> 
> I understand why it does it, but having pr_debug() named just like
> pr_info(), pr_notice(), pr_warning(), pr_err(), pr_crit(), pr_alert(),
> pr_emerg(), where all those are just printk(<LOGLEVEL>...) *except* for
> pr_debug(). That's inconsistent and wrong.
> 
> pr_debug() should have been just printk(KERN_DEBUG ...) as that follows
> convention.

The convention history is kind of inverted.

As you probably know, all the other pr_<level>
macros other than pr_info were added some years
after pr_debug.

> Yes, it's somewhat too late as pr_debug() is all over the place, but
> maybe when things slow down (Ha! like that will ever happen ... "are we
> done yet?"), then we could do a massive clean up and rename pr_debug()
> to something not so confusing in its usage compared to the other pr_*()
> prints.

g'luck with that.

Renaming pr_warning to pr_warn has taken 4 years
and it's only a 2:1 ratio in favor of pr_warn and
there are _more_ uses of pr_warning today than when
pr_warn was introduced. (1006 to 773)

cheers, Joe

