Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3HWVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:09:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55179 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3HWVJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:09:44 -0400
Date: Fri, 23 Aug 2013 23:09:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130823210942.GB16046@pd.tnic>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
 <20130823193934.GB15521@pd.tnic>
 <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:08:11PM -0400, Vince Weaver wrote:
> > 3. ioctl DETACH from it so that it is "forked in the background" so to
> > speak, very similar to a background job in the shell.
> 
> Would it make sense to actually fork a kernel thread that "owns" the 
> event?  
> 
> The way it is now events can "get loose" if either the user
> forgets about them or the tool that opened them crashes, and it's
> impossible to kill these events with normal tools.  You possibly
> wouldn't even know one was running (except you'd have one fewer
> counter to work with) unless you poked around under /sys.

Actually, the idea is to be able to reattach and control that event with
perf tool too, in addition to some specialized daemon or whatever. So
whatever else "lost" it, using perf tool you should be able to get it
back.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
