Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab3CGVnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:43:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3CGVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:43:20 -0500
Date: Thu, 7 Mar 2013 13:43:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
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
Message-Id: <20130307134318.c158500d46c7f4a1a47cf2e7@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1303072224290.22263@ionos>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
	<20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
	<5138F68A.6070203@windriver.com>
	<alpine.LFD.2.02.1303072224290.22263@ionos>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 22:25:48 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index 7664e49..86799bf 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -120,6 +120,7 @@ struct console_cmdline
> >  static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
> >  static int selected_console = -1;
> >  static int preferred_console = -1;
> > +struct console *early_console;
> >  int console_set_on_cmdline;
> >  EXPORT_SYMBOL(console_set_on_cmdline);
> >  
> > @@ -1718,7 +1719,6 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
> >  #endif /* CONFIG_PRINTK */
> >  
> >  #ifdef CONFIG_EARLY_PRINTK
> > -struct console *early_console;
> >  
> >  void early_vprintk(const char *fmt, va_list ap)
> >  {
> > 
> > 
> > Then you don't have to spray any of those ifdefs into the sparc code.
> 
> Yeah, that's what I thought as well. The extra pointer is not going to
> create massive bloat :)

It's a bit hacky though.  If CONFIG_EARLY_PRINTK=n then that code just
shouldn't exist.  If we let it persist then maybe it's doing other
wrong stuff as well.
