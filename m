Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaFEJOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:14:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaFEJOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:14:51 -0400
Date: Thu, 5 Jun 2014 11:14:49 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ftrace/x86: Use kernel identity mapping only when
 CONFIG_DEBUG_RODATA enabled
Message-ID: <20140605091449.GF7772@pathway.suse.cz>
References: <1401896566-8028-1-git-send-email-pmladek@suse.cz>
 <20140604143728.22e8cbf5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604143728.22e8cbf5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-04 14:37:28, Steven Rostedt wrote:
> On Wed,  4 Jun 2014 17:42:46 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > This is just a tiny optimization. The remapping is not needed when the
> > kernel text mapping is read write all the time.
> 
> This is true, but I think I rather have it still do it the same. The
> less variables in the code modification the better. The more changes
> per config option, the less things tend to get tested.
> 
> This is a micro optimization to something that is hardly a fast path.

It makes sense. Let's leave it as is.

Best Regards,
Petr

> > 
> > Suggested-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > ---
> >  arch/x86/kernel/ftrace.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index cbc4a91b131e..a7a517bb793e 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -79,6 +79,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
> >  
> >  static unsigned long text_ip_addr(unsigned long ip)
> >  {
> > +#ifdef CONFIG_DEBUG_RODATA
> >  	/*
> >  	 * On x86_64, kernel text mappings are mapped read-only with
> >  	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
> > @@ -89,7 +90,7 @@ static unsigned long text_ip_addr(unsigned long ip)
> >  	 */
> >  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> >  		ip = (unsigned long)__va(__pa_symbol(ip));
> > -
> > +#endif
> >  	return ip;
> >  }
> >  
> 
