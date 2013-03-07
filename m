Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3CGUFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:05:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37226 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751391Ab3CGUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:05:13 -0500
Message-ID: <1362686711.2125.3.camel@joe-AO722>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
From: Joe Perches <joe@perches.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Date: Thu, 07 Mar 2013 12:05:11 -0800
In-Reply-To: <5138EF7F.1050003@windriver.com>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
	 <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
	 <5138EF7F.1050003@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 14:50 -0500, Paul Gortmaker wrote:
> On 13-03-07 02:25 PM, Andrew Morton wrote:
> > On Thu, 7 Mar 2013 14:15:54 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >> [v2: essentially unchanged since v1, so I've left the acked/reviewed
> >>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
> >>  and PRINTK=n, because the early_console struct and early_printk calls
> >>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
> >>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
> >>  and still works for everyday sane configs too.]
> >>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   
[]
> This brings up a recurring question.  I was tempted to just go make
> CONFIG_EARLY_PRINTK depend on CONFIG_PRINTK, but lately I've faced
> pushback when trying to "fix" things like seeing ARM OMAP USB options
> for an x86 build[1], and GOLDFISH virt drivers being offered even
> when the end user already said no to GOLDFISH[2].

I think that's the right solution and I see no
obvious insurmountable downside.

http://lkml.org/lkml/2012/9/2/97


