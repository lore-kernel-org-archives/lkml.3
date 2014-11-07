Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaKGSVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:21:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKGSVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:21:06 -0500
Date: Fri, 7 Nov 2014 19:21:03 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141107182103.GE1136@dhcp128.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545B98E6.2070009@suse.cz>
 <20141106165748.GB14689@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106165748.GB14689@cerebellum.variantweb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-06 10:57:48, Seth Jennings wrote:
> On Thu, Nov 06, 2014 at 04:51:02PM +0100, Jiri Slaby wrote:
> > On 11/06/2014, 03:39 PM, Seth Jennings wrote:
> > > +/*************************************
> > > + * Core structures
> > > + ************************************/
> > > +
> > > +/*
> > > + * lp_ structs vs lpc_ structs
> > > + *
> > > + * For each element (patch, object, func) in the live-patching code,
> > > + * there are two types with two different prefixes: lp_ and lpc_.
> > > + *
> > > + * Structures used by the live-patch modules to register with this core module
> > > + * are prefixed with lp_ (live patching).  These structures are part of the
> > > + * registration API and are defined in livepatch.h.  The structures used
> > > + * internally by this core module are prefixed with lpc_ (live patching core).
> > > + */
> > 
> > I am not sure if the separation and the allocations/kobj handling are
> > worth it. It makes the code really less understandable. Can we have just
> > struct lip_function (don't unnecessarily abbreviate), lip_objectfile
> > (object is too generic, like Java object) and lip_patch containing all
> > the needed information? It would clean up the code a lot. (Yes, we would
> > have profited from c++ here.)
> 
> I looked at doing this and this is actually what we did in kpatch.  We
> made one structure that had "private" members that the user wasn't
> suppose to access that were only used in the core.  This was messy
> though.  Every time you wanted to add a "private" field to the struct so
> the core could do something new, you were changing the API to the patch
> modules as well.  While copying the data into an internal structure does
> add code and opportunity for errors, that functionality is localized
> into functions that are specifically tasked with taking care of that.
> So the risk is minimized and we gain flexibility within the core and
> more self-documenting API structures.

I am not sure if the modified API is really such a big limit. The
modules initialize the needed members using ".member = value".
Also we do not need to take care of API/ABI backward compatibility because
there is very strict dependency between patches and the patched
kernel.

Well, I have to think more about it.

Best Regards,
Petr
