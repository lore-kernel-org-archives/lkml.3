Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3DVMk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:40:26 -0400
Received: from fbr03.mfg.siteprotect.com ([64.26.60.138]:57795 "EHLO
	fbr03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3DVMkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:40:23 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2013 08:40:23 EDT
Date: Mon, 22 Apr 2013 08:33:04 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        tglx@linutronix.de, tt.rantala@gmail.com
Subject: Re: [tip:perf/urgent] perf: Treat attr.config as u64 in
 perf_swevent_init()
In-Reply-To: <1366283828.19383.7.camel@laptop>
Message-ID: <alpine.DEB.2.02.1304220831460.17487@pianoman.cluster.toy>
References: <1365882554-30259-1-git-send-email-tt.rantala@gmail.com>  <tip-8176cced706b5e5d15887584150764894e94e02f@git.kernel.org> <1366283828.19383.7.camel@laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.51752E09.00FB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Peter Zijlstra wrote:

> On Mon, 2013-04-15 at 03:42 -0700, tip-bot for Tommi Rantala wrote:
> > Commit-ID:  8176cced706b5e5d15887584150764894e94e02f
> > Gitweb:     http://git.kernel.org/tip/8176cced706b5e5d15887584150764894e94e02f
> > Author:     Tommi Rantala <tt.rantala@gmail.com>
> > AuthorDate: Sat, 13 Apr 2013 22:49:14 +0300
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Mon, 15 Apr 2013 11:42:12 +0200
> > 
> > perf: Treat attr.config as u64 in perf_swevent_init()
> > 
> > Trinity discovered that we fail to check all 64 bits of
> > attr.config passed by user space, resulting to out-of-bounds
> > access of the perf_swevent_enabled array in
> > sw_perf_event_destroy().
> 
> Gah, I so missed we could hide bits in the top word and then use them
> in _destroy().
> 
> The alternative is of course to also truncate to int in _destroy(), but
> yes keeping the natural size seems the best alternative.

has this been marked for stable now that it's in 3.9-rc8?  It's trivial to 
oops/lock the kernel with a few line program and the problem has been 
around a while.

Vince

