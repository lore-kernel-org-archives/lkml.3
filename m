Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKQTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaKQTNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:13:43 -0500
Date: Mon, 17 Nov 2014 13:13:07 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
Message-ID: <20141117191307.GA21392@cerebellum.variantweb.net>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-3-git-send-email-sjenning@redhat.com>
 <20141117184558.GA13995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117184558.GA13995@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:45:58AM -0800, Greg KH wrote:
> On Sun, Nov 16, 2014 at 07:29:23PM -0600, Seth Jennings wrote:
> > +#ifdef CONFIG_X86_32
> > +int lpc_write_module_reloc(struct module *mod, unsigned long type,
> > +			   unsigned long loc, unsigned long value)
> > +{
> > +	pr_err("Live patching not supported on 32-bit x86\n");
> > +	return -ENOSYS;
> > +}
> 
> Why not just prevent the code from being built on x86_32 instead of
> putting this in the file?

Yep. Masami saw this too and recommended a ARCH_HAVE_LIVE_PATCHING flag
set by the archs that support it.  I'll make the change.

Thanks for the review!

Seth

> 
> thanks,
> 
> greg k-h
