Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbaKUOlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:41:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbaKUOlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:41:03 -0500
Date: Fri, 21 Nov 2014 15:41:10 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <20141120195637.GC13785@cerebellum.variantweb.net>
Message-ID: <alpine.LNX.2.00.1411211538240.27891@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411201359440.21690@pobox.suse.cz> <20141120173552.GA20462@treble.redhat.com>
 <20141120195637.GC13785@cerebellum.variantweb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Seth Jennings wrote:

> On Thu, Nov 20, 2014 at 11:35:52AM -0600, Josh Poimboeuf wrote:
> > On Thu, Nov 20, 2014 at 02:10:33PM +0100, Miroslav Benes wrote:
> > > 
> > > On Sun, 16 Nov 2014, Seth Jennings wrote:
> > > 
> > > > This commit introduces code for the live patching core.  It implements
> > > > an ftrace-based mechanism and kernel interface for doing live patching
> > > > of kernel and kernel module functions.
> > > > 
> > > > It represents the greatest common functionality set between kpatch and
> > > > kgraft and can accept patches built using either method.
> > > > 
> > > > This first version does not implement any consistency mechanism that
> > > > ensures that old and new code do not run together.  In practice, ~90% of
> > > > CVEs are safe to apply in this way, since they simply add a conditional
> > > > check.  However, any function change that can not execute safely with
> > > > the old version of the function can _not_ be safely applied in this
> > > > version.
> > > > 
> > > > Signed-off-by: Seth Jennings <sjenning@redhat.com>
> > > 
> > > Hi,
> > > 
> > > below is the patch which merges the internal and external data structures 
> > > (so it is only one part of our original patch for version 1). Apart from 
> > > that I tried to make minimal changes to the code. Only unnecessary 
> > > kobjects were removed and I renamed lpc_create_* functions to lpc_init_* 
> > > as it made more sense in this approach, I think.
> > > 
> > > I hope this clearly shows our point of view stated previously. What do 
> > > you say?
> > 
> > Thanks for rebasing to v2 and splitting up the patches!  Personally I'm
> > ok with this patch (though I do have a few comments below).
> 
> Thanks Josh :)
> 
> Miroslav, before you send out a revision on this patch, I'm merging it
> for v3 right now.  I'll fixup any trivial fixes from this email.
> 
> I'm putting the finishing touches on v3 now.  Hopefully it will make
> everyone happy, or happier, with your changes merged.  Should be getting
> close...
> 
> Thanks,
> Seth

Ok, thank you for the fixes and merging. I'll take a closer look at v3 to 
be sure that everything is ok.

Mira
