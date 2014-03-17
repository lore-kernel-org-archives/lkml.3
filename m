Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaCQW16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:27:58 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56206 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753162AbaCQW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:27:55 -0400
Date: Mon, 17 Mar 2014 22:27:36 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
	tree
Message-ID: <20140317222736.GB3708@flint.arm.linux.org.uk>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au> <20140317080122.459ff9d4@infradead.org> <20140317182953.GA10565@kroah.com> <20140317162937.2ccdec83@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317162937.2ccdec83@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:29:37PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Mar 2014 11:29:53 -0700
> Greg KH <greg@kroah.com> escreveu:
> 
> > On Mon, Mar 17, 2014 at 08:01:22AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 17 Mar 2014 18:55:42 +1100
> > > Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
> > > 
> > > > Hi Greg,
> > > > 
> > > > Today's linux-next merge of the staging tree got a conflict in
> > > > drivers/media/platform/exynos4-is/fimc-is.c between commit d265d9ac6c7c
> > > > ("[media] exynos4-is: Use external s5k6a3 sensor driver") from the
> > > > v4l-dvb tree and commit fd9fdb78a9bf ("[media] of: move graph helpers
> > > > from drivers/media/v4l2-core to drivers/of") from the staging tree.
> > > > I fixed it up (see below, though I suspect it is wasted?) and can carry
> > > > the fix as necessary (no action is required).
> > > 
> > > I used to have those OF patches on my tree, but I was forced to remove,
> > > as Grant rejected the patches. After his nack, lots of dicussions about
> > > the DT bindings started and, until last week, there were no consensus
> > > about that (as far as I followed the discussions).
> > > 
> > > So, reluctantly, I just dropped this series from my tree, pretending
> > > it never existed, as reverting them could cause troubles if it 
> > > (or some version of it) got merged via Greg, Grant and/or Russell
> > > trees.
> > > 
> > > On my head, it become too late to merge it for 3.15, as first
> > > people must agree on the DT bindings. Also, I already closed the
> > > media merge window, as -rc7 seems to be the last -rc.
> > > 
> > > One possible approach for this would be to merge the patches that move
> > > the OF graph code away from drivers/media, and the corresponding
> > > internal ABI changes early at -rc, and applying the DT binding
> > > patches, and the staging imx-drm driver for 3.16.
> > 
> > I don't understand, was I supposed to do something in my staging-next
> > tree for this as well?
> > 
> > totally confused,
> 
> Hi Greg,
> 
> Let me summarize what was discussed so far with regards to it.
> 
> There are two changesets related to this:
> - a 6 patch series moving OF graph functions from
>   /drivers/media to /drivers/of;
> - a 12 patch series (at version 11 - not sure if are there any
>   newer version) that adds the imx-drm driver to staging.

No, it's not adding the imx-drm driver to staging, that driver has been
there for getting on for 18 months.  What Grant's nack does is destroy
the work which both Philipp and myself have put in to try and get this
out of staging for (maybe) 3.16.

The individual status of the patches are:

  of: move graph helpers from drivers/media/v4l2-core to drivers/of

"This patch is fine because it only moves code, but I'm not providing an
 ack yet.  I'll supply one when I'm happy with the collection of fixups."

though there is more discussion of a previous patch version.

  Documentation: of: Document graph bindings

"See my comments on the previous version. My concerns are the handling of
 the optional 'ports' node and the usage of reverse links."

The odd thing is that this patch is only documenting what is /already/ in
the kernel, and has /already/ been reviewed by Grant and Rob as DT
maintainers as part of the v4l2 OF graph parsing code.  It's rather late
to object to it now.

Grant has subsequently acked all these cleanup patches:

  of: Warn if of_graph_get_next_endpoint is called with the root node
  of: Reduce indentation in of_graph_get_next_endpoint
  of: move common endpoint parsing to drivers/of

The following was totally ignored, even though it was a simple patch:

  of: Warn if of_graph_parse_endpoint is called with the root node

and the last patch is a build fix for the previous patches.

And to top it off, Grant seems to have gone non-responsive again during
the last week.

Now, what Grant's most recent response (10 March) said was:
| It means any tree containing that branch *must* be rewound. See my reply
| to rmk. I've made a proposal on how I could be happy with leaving the
| branches alone. I'm not particularly happy, but there is a way to
| resolve things without reverts or rewinds.

What Grant doesn't realise is that his last reply to me was in response to
an email I sent privately to Grant, so the reply is private.  Policy is
not to share private emails publically.

It was based upon solving Grant's objections, which as agreement hasn't
been reached, hasn't happened.

However, I still find myself coming back to a fundamental question: why
were these bindings fine in April 2013, passed review, and were acked,
but not fine today.  Here's the links to the emails acking their
introduction which Sylwester Nawrocki sent me:

  http://www.spinics.net/lists/linux-media/msg61899.html
  http://www.spinics.net/lists/linux-media/msg62458.html

So... *shrug*.  Make of this what you will.

-- 
Russell King
ARM architecture Linux Kernel maintainer
