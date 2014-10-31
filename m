Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaJaTeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:34:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaJaTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:34:10 -0400
Date: Fri, 31 Oct 2014 20:34:08 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for
	CONFIG_BACKPORT
Message-ID: <20141031193408.GA12953@wotan.suse.de>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com> <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com> <1414741273.3014.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414741273.3014.3.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:41:13AM +0100, Johannes Berg wrote:
> On Wed, 2014-10-29 at 01:21 -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > In order to support built-in kernel integration we want to use
> > a more generic approach to defining symbols, CPTCFG was nice as
> > it was short and relied on the fact that kconfig can work with
> > a getenv(CONFIG_) but for kernel integration this doesn't work
> > so well. Instead let's just stick to the regular CONFIG_
> > namespace and add the BACKPORT prefix to it.
> > 
> > Apart from these expected changes:
> > 
> > for i in $(find ./  | grep -v "\.git"); do perl -pi -e'$_ =~ s|CPTCFG|CONFIG_BACKPORT|gs;' $i; done
> 
> I really think you need to make this optional for the in-tree
> generation, otherwise it will complicate things a lot for anyone who's
> already using backports in a way that doesn't have it regenerated all
> the time.

Logistically I do agree this will implicate tons of merge conflicts
if a git tree was used for development based on backports, however
functionally I don't expect this this to create divergence.

> Additionally, CPTCFG_ had the advantage of having the same length as
> CONFIG_, so code style wise it was nicer to replace.
> 
> Please make this a post-process step that runs on everything, including
> the backport stuff, rather than running only on the source and assuming
> the backport stuff already uses this convention.

I want to but lets consider the amount of work to maintain the two
separate approaches, is it worth it?

  Luis
