Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKEU31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:29:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaKEU3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:29:24 -0500
Date: Wed, 5 Nov 2014 21:29:23 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 09/13] backports: define C code backport version
	info using CPTCFG_
Message-ID: <20141105202923.GR12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-10-git-send-email-mcgrof@do-not-panic.com> <1415174245.2589.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415174245.2589.9.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:57:25AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > In order to help unify the naming scheme for shared
> > backports versioning information rely on the CPTCFG_
> > prefix, when integration support gets added that will
> > translate to the respective CONFIG_BACKPORT_ prefix.
> > Kconfig opt env entries don't get propagated out, so
> > we need to define these ourselves. This leaves all
> > other names in place for packaging and just focuses
> > on sharing on the C / header code.
> 
> What difference does this make? It'll break some scripting that we have
> for sure (assuming the BACKPORTED_ prefix), so naturally I'd like to see
> why it is necessary.

Sure, let me explain. So if we don't unify we will have to end up with defines
for some packaging version scheme to another. The approach I took here was to
minimize impact on on userspace side generation side of things and only
affect the target C code by modifying the Makefile to define variables
we can share. That's pretty much it. I ended up defining things with
CPTCFG_ as that will get morphed to the other bp_prefix later for us
when integrating. That lets us share it.

Addressing this on scripts that do rely on touching C / H files should
just be a matter of doing a direct translation to 3 variables.

  Luis
