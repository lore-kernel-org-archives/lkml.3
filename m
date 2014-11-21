Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbaKUQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:42:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbaKUQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:42:31 -0500
Date: Fri, 21 Nov 2014 10:41:48 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/3] kernel: add sysfs documentation for live patching
Message-ID: <20141121164148.GC11339@cerebellum.variantweb.net>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-4-git-send-email-sjenning@redhat.com>
 <546EA84A.5070607@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546EA84A.5070607@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:49:46AM +0900, Masami Hiramatsu wrote:
> (2014/11/21 7:29), Seth Jennings wrote:
> > Adds sysfs interface documentation to Documentation/ABI/testing/
> > 
> 
> Hmm, is there any reason to decouple this documentation from code patch?
> I think we'd better merge this to 2/3, or move sysfs interface code from 2/3 to this.

Good point.  I'll collapse this into 2/3 for v4.

Thanks,
Seth

> 
> Thank you,
> 
> > Signed-off-by: Seth Jennings <sjenning@redhat.com>
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-livepatch | 44 ++++++++++++++++++++++++
> >  MAINTAINERS                                      |  1 +
> >  2 files changed, 45 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-kernel-livepatch
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > new file mode 100644
> > index 0000000..5bf42a8
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > @@ -0,0 +1,44 @@
> > +What:		/sys/kernel/livepatch
> > +Date:		Nov 2014
> > +KernelVersion:	3.19.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		Interface for kernel live patching
> > +
> > +		The /sys/kernel/livepatch directory contains subdirectories for
> > +		each loaded live patch module.
> > +
> > +What:		/sys/kernel/livepatch/<patch>
> > +Date:		Nov 2014
> > +KernelVersion:	3.19.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		The patch directory contains subdirectories for each kernel
> > +		object (vmlinux or a module) in which it patched functions.
> > +
> > +What:		/sys/kernel/livepatch/<patch>/enabled
> > +Date:		Nov 2014
> > +KernelVersion:	3.19.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		A writable attribute that indicates whether the patched
> > +		code is currently applied.  Writing 0 will disable the patch
> > +		while writing 1 will re-enable the patch.
> > +
> > +What:		/sys/kernel/livepatch/<patch>/<object>
> > +Date:		Nov 2014
> > +KernelVersion:	3.19.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		The object directory contains subdirectories for each function
> > +		that is patched within the object.
> > +
> > +What:		/sys/kernel/livepatch/<patch>/<object>/<function>
> > +Date:		Nov 2014
> > +KernelVersion:	3.19.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		The function directory contains attributes regarding the
> > +		properties and state of the patched function.
> > +
> > +		There are currently no such attributes.
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index c7f49ae..7985293 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5725,6 +5725,7 @@ F:	kernel/livepatch/
> >  F:	include/linux/livepatch.h
> >  F:	arch/x86/include/asm/livepatch.h
> >  F:	arch/x86/kernel/livepatch.c
> > +F:	Documentation/ABI/testing/sysfs-kernel-livepatch
> >  L:	live-patching@vger.kernel.org
> >  
> >  LLC (802.2)
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
