Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaESTZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:25:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46278 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaESTZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:25:22 -0400
Date: Mon, 19 May 2014 21:25:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
Message-ID: <20140519192501.GD6311@pd.tnic>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
 <1400526771.14238.15.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400526771.14238.15.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:12:51PM -0700, Joe Perches wrote:
> On Mon, 2014-05-19 at 20:27 +0200, Borislav Petkov wrote:
> > ... instead of naked numbers.
> 
> Seems sensible.
> 
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> []
> > @@ -30,6 +30,17 @@ static inline const char *printk_skip_level(const char *buffer)
> >  	return buffer;
> >  }
> >  
> > +/* printk's without a loglevel use this.. */
> > +#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
> 
> Does anyone actually set CONFIG_DEFAULT_MESSAGE_LOGLEVEL
> to something other than 4?
> 
> > +/* We show everything that is MORE important than this.. */
> 
> It might be nice to show somewhere that larger values are
> less important.
> 
> > +#define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
> > +#define CONSOLE_LOGLEVEL_MIN	 1 /* Minimum loglevel we let people use */
> > +#define CONSOLE_LOGLEVEL_QUIET	 4 /* Shhh ..., when booted with "quiet" */
> > +#define CONSOLE_LOGLEVEL_DEFAULT 7 /* anything MORE serious than KERN_DEBUG */
> > +#define CONSOLE_LOGLEVEL_DEBUG	10 /* issue debug messages */
> > +#define CONSOLE_LOGLEVEL_MOTORMOUTH 15	/* You can't shut this one up */
> 
> It may be nicer to have #defines for the
> KERN_<LEVEL> numbers from kern_levels.h
> and use those here.
> 
> Maybe add:
> 
> #define LOGLEVEL_EMERG		0
> #define LOGLEVEL_ALERT		1
> #define LOGLEVEL_CRIT		2
> #define LOGLEVEL_ERR		3
> #define LOGLEVEL_WARNING	4
> #define LOGLEVEL_NOTICE		5
> #define LOGLEVEL_INFO		6
> #define LOGLEVEL_DEBUG		7
> 
> That could clean up a few uses of
> magic numbers like 7 in dev_printk_emit

This patch is supposed to be as obvious as possible - all other things
which need/must/will be done should come ontop, not here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
