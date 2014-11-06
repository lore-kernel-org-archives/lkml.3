Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaKFUT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:19:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFUT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:19:26 -0500
Date: Thu, 6 Nov 2014 14:19:19 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106201919.GA19701@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <20141106150204.38c600cf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106150204.38c600cf@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:02:04PM -0500, Steven Rostedt wrote:
> On Thu,  6 Nov 2014 08:39:08 -0600
> Seth Jennings <sjenning@redhat.com> wrote:
> 
> > --- /dev/null
> > +++ b/kernel/livepatch/Kconfig
> > @@ -0,0 +1,11 @@
> > +config LIVE_PATCHING
> > +	tristate "Live Kernel Patching"
> > +	depends on DYNAMIC_FTRACE_WITH_REGS && MODULES && SYSFS && KALLSYMS_ALL
> > +	default m
> 
> Nuke this default. This should be default 'n', which is what kconfig
> defaults to when none is mentioned.

Ok.

Thanks,
Seth

> 
> -- Steve
> 
> > +	help
> > +	  Say Y here if you want to support live kernel patching.
> > +	  This setting has no runtime impact until a live-patch
> > +	  kernel module that uses the live-patch interface provided
> > +	  by this option is loaded, resulting in calls to patched
> > +	  functions being redirected to the new function code contained
> > +	  in the live-patch module.
