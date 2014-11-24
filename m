Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaKXNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbaKXNZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:25:25 -0500
Date: Mon, 24 Nov 2014 07:24:37 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141124132437.GA6235@treble.redhat.com>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.DEB.2.11.1411241209050.6439@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411241209050.6439@nanos>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:13:20PM +0100, Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> > 
> > It represents the greatest common functionality set between kpatch and
> > kgraft and can accept patches built using either method.
> > 
> > This first version does not implement any consistency mechanism that
> > ensures that old and new code do not run together.  In practice, ~90% of
> > CVEs are safe to apply in this way, since they simply add a conditional
> > check.  However, any function change that can not execute safely with
> > the old version of the function can _not_ be safely applied in this
> > version.
> 
> To be honest this sounds frightening.

The risky part of live patching is patch analysis and creation.  If the
user isn't careful with their analysis, they're playing with fire.

We'll be documenting the patch analysis steps, so that if you carefully
follow the steps, it's safe.  But that should generally be the role of
the distribution.

> How is determined whether a change can be applied w/o a consistency
> mechanism or not?

The following are not safe without consistency mechanisms:

- function prototype changes
- data structure changes
- data semantic changes: changes to how functions interact with a data
  structure, e.g. locking order

We'll be adding the consistency mechanisms later to enable function and
data consistency.  But even then you have to be very careful.

-- 
Josh
