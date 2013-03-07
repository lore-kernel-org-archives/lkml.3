Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab3CGWeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:34:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:51469 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3CGWec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:34:32 -0500
Date: Thu, 7 Mar 2013 23:34:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
In-Reply-To: <20130307134318.c158500d46c7f4a1a47cf2e7@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1303072330520.22263@ionos>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com> <20130307112536.82288f41924a38a441cdf345@linux-foundation.org> <5138F68A.6070203@windriver.com> <alpine.LFD.2.02.1303072224290.22263@ionos>
 <20130307134318.c158500d46c7f4a1a47cf2e7@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013, Andrew Morton wrote:

> On Thu, 7 Mar 2013 22:25:48 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > diff --git a/kernel/printk.c b/kernel/printk.c
> > > index 7664e49..86799bf 100644
> > > --- a/kernel/printk.c
> > > +++ b/kernel/printk.c
> > > @@ -120,6 +120,7 @@ struct console_cmdline
> > >  static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
> > >  static int selected_console = -1;
> > >  static int preferred_console = -1;
> > > +struct console *early_console;
> > >  int console_set_on_cmdline;
> > >  EXPORT_SYMBOL(console_set_on_cmdline);
> > >  
> > > @@ -1718,7 +1719,6 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
> > >  #endif /* CONFIG_PRINTK */
> > >  
> > >  #ifdef CONFIG_EARLY_PRINTK
> > > -struct console *early_console;
> > >  
> > >  void early_vprintk(const char *fmt, va_list ap)
> > >  {
> > > 
> > > 
> > > Then you don't have to spray any of those ifdefs into the sparc code.
> > 
> > Yeah, that's what I thought as well. The extra pointer is not going to
> > create massive bloat :)
> 
> It's a bit hacky though.  If CONFIG_EARLY_PRINTK=n then that code just
> shouldn't exist.  If we let it persist then maybe it's doing other
> wrong stuff as well.

Agreed.

Looking again it turns out that sparc does not fall into the early
console category. While it uses the early_printk naming convention it
does not use the early_vprintk stuff which I consolidated out of the
other architectures. So the sparc part of the patch simply wants to be
reverted.
 
Thanks,

	tglx
