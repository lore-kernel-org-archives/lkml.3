Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbaKUPVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:21:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbaKUPVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:21:41 -0500
Date: Fri, 21 Nov 2014 09:21:03 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141121152103.GB26264@treble.redhat.com>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:22:33AM +0100, Jiri Kosina wrote:
> On Thu, 20 Nov 2014, Seth Jennings wrote:
> > --- /dev/null
> > +++ b/kernel/livepatch/Kconfig
> > @@ -0,0 +1,18 @@
> > +config ARCH_HAVE_LIVE_PATCHING
> > +	boolean
> > +	help
> > +	  Arch supports kernel live patching
> > +
> > +config LIVE_PATCHING
> > +	boolean "Kernel Live Patching"
> > +	depends on DYNAMIC_FTRACE_WITH_REGS
> > +	depends on MODULES
> > +	depends on SYSFS
> > +	depends on KALLSYMS_ALL
> > +	depends on ARCH_HAVE_LIVE_PATCHING
> 
> We have to refuse to build on x86_64 if the compiler doesn't support 
> fentry. mcount is not really usable (well, it would be possible to use it, 
> be the obstacles are too big to care).
> 
> Something like [1] should be applicable here as well I believe.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/commit/?h=kgraft&id=bd4bc097c72937d18036f1312a4d79ed0bea9991

I think we can use "depends on HAVE_FENTRY" to accomplish this, since
CC_USING_FENTRY gets set by the top level kernel Makefile if
CONFIG_HAVE_FENTRY is set.

-- 
Josh
