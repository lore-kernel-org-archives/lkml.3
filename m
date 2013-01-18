Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3ARWQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:16:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:28080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3ARWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:16:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="278824803"
Date: Fri, 18 Jan 2013 14:16:14 -0800
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: IPsec AH use of ahash
Message-ID: <20130118221614.GA5616@ppwaskie-mobl2.amr.corp.intel.com>
References: <20130118.145005.156366015893075594.davem@davemloft.net>
 <220318679.90938.1358542424387.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <220318679.90938.1358542424387.JavaMail.root@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 03:53:44PM -0500, Tom St Denis wrote:
> Admittedly I'm new to the kernel scene but what exactly is a "maintainer" then?

Maintainers are ultimately responsible for content that flows into a tree
or subsystem.  That means they must command a level of expertise on
everything about the code they maintain to decide what goes in and what
doesn't.  This doesn't mean they know everything about everything, but
their judgement is built on experience and time in the job.

> Suppose I invest time to re-write the IPv4/v6 AH code to correctly use AEAD instead of ahash, to then perform the testing required, etc... do I get credit as a maintainer in the IPsec tree?

Working on a single thing doesn't make you a maintainer, it makes you a
contributor.  There are vastly more contributors than maintainers, and that's
how it should be.  A maintainer depends on contributors to be the people
in the trenches dealing with the specifics of things like the AH code, in
this case.  However, a maintainer's signed-off-by on a contributor's code
also makes the maintainer accountable for the code being included in the
kernel.  This is not something to be taken lightly.

> I'm also a little annoyed that my CMAC patch was rejected for among other reasons that it violated "coding standards."  Specially since it was almost entirely copied from crypto/xcbc.c which also violates the same rules.  As a newcomer to the tree I tried my best by emulating readily available code (which apparently was already accepted into the tree) to then just get shot down for attempting to contribute.  If my CMAC code is not good enough for the tree I humbly suggest you also remove the XCBC code too while we're at it.

I would recommend just hanging out on the netdev list and read it for a few
days.  There are a *large* number of patches that are critiqued and asked
to either be rewritten, modified, or dropped.  The whole point of the
community is to share your work and code, and then either defend the code,
or incorporate feedback and resubmit.  Many patches take multiple spins before
they're applied.  It's the nature of the community.

Note that quite a bit of code has been in the kernel for a long time.  There
will be examples of code that doesn't conform; there are millions of lines of
code in Linux, nothing is going to be perfect.  If you find your code doesn't
meet a coding standard, then respin the patch, and then use that opportunity
to fix the other code you've seen to meet the coding standard.  That's two
contributions that only improve the kernel, and increases your credibility
as an active contributor.

> What I would expect from the "maintainers" is that they actually take on a more than trivial involvement in the progress of the code.  If I have to create original content and massage it into whatever form pleases the owners of the tree am I not the maintainer of the code?  I was honestly expecting someone with more involvement in the tree to move the [in this case] CMAC patch forward.  

I'd suggest you go look at patchwork.ozlabs.org and look at the queues of
patches that various maintainers are juggling.  Maintainers offer feedback and
review when they can, but they rely on other contributors to really vet the
code.  And the fact that David responded at all shouldn't be viewed as
trivial involvement, he's one of the most busy maintainers in the kernel.

Cheers,
-PJ
