Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaJaUWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:22:31 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:54021 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaJaUW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:22:29 -0400
Message-ID: <1414786943.3014.37.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for
 CONFIG_BACKPORT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Fri, 31 Oct 2014 21:22:23 +0100
In-Reply-To: <20141031193408.GA12953@wotan.suse.de>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
	 <1414741273.3014.3.camel@jlt4.sipsolutions.net>
	 <20141031193408.GA12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 20:34 +0100, Luis R. Rodriguez wrote:

> > I really think you need to make this optional for the in-tree
> > generation, otherwise it will complicate things a lot for anyone who's
> > already using backports in a way that doesn't have it regenerated all
> > the time.
> 
> Logistically I do agree this will implicate tons of merge conflicts
> if a git tree was used for development based on backports, however
> functionally I don't expect this this to create divergence.

Agree, but it's going to be a nightmare from the merge point of view,
and also the CPTCFG_ is nicer to replace back and forth between
backports-based development and the kernel, due to this:

> > Additionally, CPTCFG_ had the advantage of having the same length as
> > CONFIG_, so code style wise it was nicer to replace.



> > Please make this a post-process step that runs on everything, including
> > the backport stuff, rather than running only on the source and assuming
> > the backport stuff already uses this convention.
> 
> I want to but lets consider the amount of work to maintain the two
> separate approaches, is it worth it?

I don't see why it'd be maintaining two approaches? Right now we have
scripting to replace CONFIG_ with CPTCFG_, so couldn't we just add more
scripting to replace CPTCFG_ with CONFIG_BACKPORT_ ?

That also makes me think of something else - we currently use BACKPORT_
as a prefix for some of the other stuff under compat/Kconfig, and in
fact rename some things (like CONFIG_BACKPORT_AVERAGE) so maybe also
using CONFIG_BACKPORT_ here isn't a great idea? Might want to use
something else, say CONFIG_BPT_ or so.

johannes

