Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbbAHAds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:33:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbAHAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:33:47 -0500
Date: Wed, 7 Jan 2015 16:33:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: livepatching tree for linux-next
Message-Id: <20150107163345.ae3ed8f2e4501e258ff01512@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
	<20141226155613.36dd95b9@canb.auug.org.au>
	<20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
	<alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
	<20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
	<alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz>
	<20150107155701.4839545f63701412003edd88@linux-foundation.org>
	<alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015 01:11:03 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 7 Jan 2015, Andrew Morton wrote:
> 
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -911,6 +911,12 @@ static int klp_init(void)
> > >  {
> > >  	int ret;
> > >  
> > > +	ret = klp_check_compiler_support();
> > > +	if (ret) {
> > > +		pr_info("Your compiler is too old; turning off.\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > 
> > Looks reasonable.  
> 
> Thanks. Can I treat this as your Reported-and-tested-by .. ?

I compile tested it.  Then I got bored trying to hunt down all the
Kconfig things I needed to turn on to runtime test it ;)

btw, I suggest using HAVE_LIVE_PATCHING instead of
ARCH_HAVE_LIVE_PATCHING.  because this:

akpm3:/usr/src/25> grep " HAVE_" arch/x86/Kconfig | wc -l
67
akpm3:/usr/src/25> grep " ARCH_HAVE_" arch/x86/Kconfig | wc -l  
3
akpm3:/usr/src/25> grep " ARCH_HAS_" arch/x86/Kconfig | wc -l   
7
akpm3:/usr/src/25> grep " HAVE_ARCH" arch/x86/Kconfig | wc -l         
8
akpm3:/usr/src/25> grep " ARCH_USE" arch/x86/Kconfig | wc -l     
4
akpm3:/usr/src/25> grep " ARCH_WANT" arch/x86/Kconfig | wc -l   
6

makes me cry.

