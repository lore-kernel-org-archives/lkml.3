Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbbAIKDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:03:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbbAIKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:03:38 -0500
Date: Fri, 9 Jan 2015 11:03:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: livepatching tree for linux-next
In-Reply-To: <20150107155701.4839545f63701412003edd88@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1501091100530.15299@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
 <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org> <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz> <20150107155701.4839545f63701412003edd88@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Andrew Morton wrote:

> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -911,6 +911,12 @@ static int klp_init(void)
> >  {
> >  	int ret;
> >  
> > +	ret = klp_check_compiler_support();
> > +	if (ret) {
> > +		pr_info("Your compiler is too old; turning off.\n");
> > +		return -EINVAL;
> > +	}
> > +
> 
> Looks reasonable.  

I've applied it and pushed out.

> It's a shame we've never figured out a way to do this at Kconfig-time.

The biggest problems probably is: what if you supply different CC during 
build? Then you'll have to invalidate all dependencies and restart the 
whole dependency resolution. The same goes for cross-compilation I guess.

-- 
Jiri Kosina
SUSE Labs
