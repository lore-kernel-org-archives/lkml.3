Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaLAQt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:49:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbaLAQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:49:55 -0500
Date: Mon, 1 Dec 2014 10:49:46 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141201164946.GA11179@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545B98E6.2070009@suse.cz>
 <20141130122348.GA13426@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141130122348.GA13426@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 01:23:48PM +0100, Pavel Machek wrote:
> On Thu 2014-11-06 16:51:02, Jiri Slaby wrote:
> > On 11/06/2014, 03:39 PM, Seth Jennings wrote:
> > > This commit introduces code for the live patching core.  It implements
> > > an ftrace-based mechanism and kernel interface for doing live patching
> > > of kernel and kernel module functions.
> > 
> > Hi,
> > 
> > nice! So we have something to start with. Brilliant!
> > 
> > I have some comments below now. Yet, it obviously needs deeper review
> > which will take more time.
> > 
> > > --- /dev/null
> > > +++ b/include/linux/livepatch.h
> > > @@ -0,0 +1,45 @@
> > > +#ifndef _LIVEPATCH_H_
> > > +#define _LIVEPATCH_H_
> > 
> > This should follow the linux kernel naming: LINUX_LIVEPATCH_H
> > 
> > 
> > > +#include <linux/module.h>
> > > +
> > > +struct lp_func {
> > 
> > I am not much happy with "lp" which effectively means parallel printer
> > support. What about lip?
> 
> What about "patch_"?

Hey Pavel,

We are on v4 of this patchset:
https://lkml.org/lkml/2014/11/25/868

We ended up going with klp_ (kernel live patching).

Thanks,
Seth

> 
> It is not so big subsystem that additional typing would matter much...
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
