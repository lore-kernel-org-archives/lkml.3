Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaKDXdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:33:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaKDXdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:33:39 -0500
Date: Wed, 5 Nov 2014 00:33:38 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 09/11] backports: use Kconfig for backport version
	information
Message-ID: <20141104233338.GH12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-10-git-send-email-mcgrof@do-not-panic.com> <1415095985.2064.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415095985.2064.12.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:13:05AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 00:43 -0800, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > Instead of relying on Makefile hacks just use Kconfig for
> > defining the variables needed. We can do this since these
> > variables are all known at packaging time. The exception
> > is BACKPORTS_GIT_TRACKED, but for that we can define a
> > kconfig variable which only if set will we rely on the
> > environment for picking it up and later exporting it through
> > Kconfig. Since Kconfig doesn't keep config variables defined
> > with option env we use a secondary config entry for that.
> 
> I'd prefer you didn't do this. When we track the backports in a git tree
> this will mean constant changes to these files, where currently the
> changes are constrained to just the "versions" file.

I wanted to at least unify the C code defines for the shared
versioning information, I've come up with a way that
minimizes the changes to the existing packaging stuff,
will send in my respin. Hopefully that's OK.

  Luis
