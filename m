Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3GIUlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:41:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36317 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3GIUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:41:00 -0400
Date: Tue, 9 Jul 2013 16:40:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jan Beulich <JBeulich@suse.com>, Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, x86@kernel.org, tglx@linutronix.de,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, mingo@redhat.com,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130709204011.GA11984@phenom.dumpdata.com>
References: <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com>
 <20130708205834.GA481@pd.tnic>
 <1373326534.1438.10.camel@x61.thuisdomein>
 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
 <51DBDAB802000078000E37C1@nat28.tlf.novell.com>
 <20130709144840.GF24897@phenom.dumpdata.com>
 <20130709150554.GA27579@pd.tnic>
 <20130709171909.GA25586@phenom.dumpdata.com>
 <20130709200150.GB27579@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709200150.GB27579@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 10:01:50PM +0200, Borislav Petkov wrote:
> On Tue, Jul 09, 2013 at 01:19:09PM -0400, Konrad Rzeszutek Wilk wrote:
> > My thinking is that what should be done to have some sense of history
> > is that the patch in GRUB to not rely on kernel internals should be
> > done. Then that git commit of that tree should be mentioned in this
> > kernel patch.
> 
> That's absolutely backwards and you know it. The two things - the kernel
> and grub2 - have a defined interface and it is the only way they should
> interact. Everything else is a bug.
> 
> > I wouldn't want GRUB2 to have regressions and stop generating the
> > proper menu options. That smells of userspace regressions and I am not
> > too keen to have Linus point this out to me.
> 
> You keep repeating that...
> 
> Dear Konrad, we need to talk about what a userspace regression is. And
> in that case, grepping through the kernel .config and suddenly not
> finding a certain symbol is not. That's like objdump-ing vmlinux and
> relying on something there.
> 
> The patch removing this symbol is not violating a defined interface to
> userspace. So you can't claim we're breaking anything here.

I am not clear what the boundary is. Let me get Linus's guidance on this
after the rc0 madness.
> 
> > Once that is done we can follow up on this patch and perhaps also
> > nicely convience the initial author of this patch to look at removing
> > the CONFIG_XEN_DOM0 and replacing them with the two other CONFIG
> > options that Jan and me have been discussing.
> 
> Yes, but please make sure there's a bug opened against grub2 which lets
> them know that grepping kernel configs is doomed to break sooner or
> later.

I presume that grub2 folks are as strained for resources as everybody else
- meaning they won't get to doing a patch until somebody screams.

If there is a bug I try to fix it. In this case it looks like the bug is grub2
and in the kernel. Hence the fix should be in both places. If it can be done
in parallel that would be great. Since we have some time to actually fix in
in both places why not do it? 
