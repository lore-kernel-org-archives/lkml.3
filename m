Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaLVRlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:41:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbaLVRlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:41:52 -0500
Date: Mon, 22 Dec 2014 11:41:17 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: use FTRACE_OPS_FL_IPMODIFY
Message-ID: <20141222174117.GB26666@treble.redhat.com>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <5492C0A9.3080303@hitachi.com>
 <20141218154935.GA6887@treble.redhat.com>
 <20141219094335.GA9571@pathway.suse.cz>
 <20141222173409.GC2494@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141222173409.GC2494@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 06:34:09PM +0100, Petr Mladek wrote:
> On Fri 2014-12-19 10:43:35, Petr Mladek wrote:
> > On Thu 2014-12-18 09:49:35, Josh Poimboeuf wrote:
> > > On Thu, Dec 18, 2014 at 08:55:21PM +0900, Masami Hiramatsu wrote:
> > > > (2014/12/17 2:58), Seth Jennings wrote:
> > > > > changes in v7:
> > > > > - TODO: set IPMODIFY (not a blocker to moving forward)
> > > > 
> > > > Why don't you set this?
> > > > IPMODIFY series are not completely applied yet, but you can already
> > > > use the flag. All you need is just set it :)
> > > 
> > > Yeah, I don't see any reason why we can't start using this flag now.
> > > How about we add this patch to the queue?
> > > 
> > > -->8--
> > > 
> > > Subject: livepatch: use FTRACE_OPS_FL_IPMODIFY
> > > 
> > > Use the FTRACE_OPS_FL_IPMODIFY flag to prevent conflicts with other
> > > ftrace users who also modify regs->ip.
> > > 
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > 
> > It makes sense. The flag is available even in 3.19.
> > 
> > Reviewed-by: Petr Mladek <pmladek@suse.cz>
> 
> Feel free to keep the Reviewed-by if you fix the typo, see below.
> 
> > > ---
> > >  kernel/livepatch/core.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 0004a71..bdd99975 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -640,7 +640,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> > >  
> > >  	ops->private = func;
> > >  	ops->func = klp_ftrace_handler;
> > > -	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
> > > +	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC |
> > > +		     FTRACE_FL_IPMODIFY;
> 
> Heh, there is a typo. Please replace FTRACE_FL_IPMODIFY
> with FTRACE_OPS_FL_IPMODIFY ;-)

Argh!  At least the commit message is correct ;-)

I'll send out a v2.

> Best Regards,
> Petr
> 
> > >  	func->fops = ops;
> > >  	func->state = KLP_DISABLED;
> > >  
> > > -- 
> > > 2.1.0
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe live-patching" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Josh
