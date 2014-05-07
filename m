Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaEGSUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:20:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62396 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750924AbaEGST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:19:59 -0400
Date: Wed, 7 May 2014 14:19:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Streetman <ddstreet@ieee.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
Message-ID: <20140507141956.4eb6ff8d@gandalf.local.home>
In-Reply-To: <1399486238.2911.20.camel@joe-AO725>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	<1399300985-11137-1-git-send-email-ddstreet@ieee.org>
	<20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
	<CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
	<20140506174445.b64dffb78d0676b48fa68eea@skynet.be>
	<CALZtONBADrb_yCPqCAUfw1ei9sYxw_-MopPko3dcfas2mqsVZg@mail.gmail.com>
	<20140507103512.5b3f7928@gandalf.local.home>
	<1399486238.2911.20.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014 11:10:38 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-05-07 at 10:35 -0400, Steven Rostedt wrote:
> > On Wed, 7 May 2014 10:21:28 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
> 
> > > It would be even better if the note could clarify that sometimes it is
> > > ok to use printk(KERN_DEBUG
> > 
> > Exactly. I think it's rather stupid to have to do a #define DEBUG to
> > have pr_debug() print in general.
> > 
> > I see no reason to have pr_debug() be anything different than the other
> > pr_*() functions.
> 
> pr_debug is meant to be disabled and have _no_ runtime
> effect unless DEBUG is #defined.

I understand why it does it, but having pr_debug() named just like
pr_info(), pr_notice(), pr_warning(), pr_err(), pr_crit(), pr_alert(),
pr_emerg(), where all those are just printk(<LOGLEVEL>...) *except* for
pr_debug(). That's inconsistent and wrong.

pr_debug() should have been just printk(KERN_DEBUG ...) as that follows
convention. Not something that gets disabled by default. For that, we
should have given it a different name. That's the point I was trying to
make.

Yes, it's somewhat too late as pr_debug() is all over the place, but
maybe when things slow down (Ha! like that will ever happen ... "are we
done yet?"), then we could do a massive clean up and rename pr_debug()
to something not so confusing in its usage compared to the other pr_*()
prints.

-- Steve

