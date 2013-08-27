Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3H0MWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:22:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40296 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3H0MWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:22:40 -0400
Date: Tue, 27 Aug 2013 14:22:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130827122242.GA5855@x1.alien8.de>
References: <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
 <20130823193934.GB15521@pd.tnic>
 <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
 <20130827115422.GD15884@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130827115422.GD15884@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:54:22PM +0200, Robert Richter wrote:
> I got another idea for this, what about UNCLAIM and CLAIM? It is
> exactly, what it is. A process unclaims an event telling it doesn't
> care anymore.  Another process comes and claims the event, meaning the
> process wants the event no longer to be shared with others and being
> released after closing.

This still doesn't pan out because with claiming the event, you state
that the event is *owned* by this process but with persistent events
we want to be able to state that they can have multiple users and thus
multiple buffer consumers, concurrently.

> > > 3. ioctl DETACH from it so that it is "forked in the background" so to
> > > speak, very similar to a background job in the shell.
> 
> With 'detach' we move the event into the 'background' so that it is
> still available after opening.

Ok, maybe ATTACH/DETACH is not the perfect naming for this after all.
Maybe when we want to state the fact that the event is going to continue
existing after closing the buffer consumer, we want to do ioctl(event,
DONT_DESTROY) and when we want to actually get rid of it, one of the
process does ioctl(event, DESTROY).

Which reminds me, what do we do when one process destroys the event but
there are other consumers accessing it concurrently? Refcounting?

Thanks.

-- 
Regards/Gruss,
Boris.
