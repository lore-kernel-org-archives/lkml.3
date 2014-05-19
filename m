Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaESTM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:12:59 -0400
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:37746 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754856AbaESTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:12:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3315:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6
X-HE-Tag: eggs22_707e89400cd28
X-Filterd-Recvd-Size: 2807
Message-ID: <1400526771.14238.15.camel@joe-AO725>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
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
Date: Mon, 19 May 2014 12:12:51 -0700
In-Reply-To: <1400524052-25625-1-git-send-email-bp@alien8.de>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 20:27 +0200, Borislav Petkov wrote:
> ... instead of naked numbers.

Seems sensible.

> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -30,6 +30,17 @@ static inline const char *printk_skip_level(const char *buffer)
>  	return buffer;
>  }
>  
> +/* printk's without a loglevel use this.. */
> +#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL

Does anyone actually set CONFIG_DEFAULT_MESSAGE_LOGLEVEL
to something other than 4?

> +/* We show everything that is MORE important than this.. */

It might be nice to show somewhere that larger values are
less important.

> +#define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
> +#define CONSOLE_LOGLEVEL_MIN	 1 /* Minimum loglevel we let people use */
> +#define CONSOLE_LOGLEVEL_QUIET	 4 /* Shhh ..., when booted with "quiet" */
> +#define CONSOLE_LOGLEVEL_DEFAULT 7 /* anything MORE serious than KERN_DEBUG */
> +#define CONSOLE_LOGLEVEL_DEBUG	10 /* issue debug messages */
> +#define CONSOLE_LOGLEVEL_MOTORMOUTH 15	/* You can't shut this one up */

It may be nicer to have #defines for the
KERN_<LEVEL> numbers from kern_levels.h
and use those here.

Maybe add:

#define LOGLEVEL_EMERG		0
#define LOGLEVEL_ALERT		1
#define LOGLEVEL_CRIT		2
#define LOGLEVEL_ERR		3
#define LOGLEVEL_WARNING	4
#define LOGLEVEL_NOTICE		5
#define LOGLEVEL_INFO		6
#define LOGLEVEL_DEBUG		7

That could clean up a few uses of
magic numbers like 7 in dev_printk_emit


