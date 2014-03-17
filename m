Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaCQT3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:29:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaCQT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:29:52 -0400
Date: Mon, 17 Mar 2014 16:29:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20140317162937.2ccdec83@infradead.org>
In-Reply-To: <20140317182953.GA10565@kroah.com>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
	<20140317080122.459ff9d4@infradead.org>
	<20140317182953.GA10565@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 17 Mar 2014 11:29:53 -0700
Greg KH <greg@kroah.com> escreveu:

> On Mon, Mar 17, 2014 at 08:01:22AM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 17 Mar 2014 18:55:42 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
> > 
> > > Hi Greg,
> > > 
> > > Today's linux-next merge of the staging tree got a conflict in
> > > drivers/media/platform/exynos4-is/fimc-is.c between commit d265d9ac6c7c
> > > ("[media] exynos4-is: Use external s5k6a3 sensor driver") from the
> > > v4l-dvb tree and commit fd9fdb78a9bf ("[media] of: move graph helpers
> > > from drivers/media/v4l2-core to drivers/of") from the staging tree.
> > > I fixed it up (see below, though I suspect it is wasted?) and can carry
> > > the fix as necessary (no action is required).
> > 
> > I used to have those OF patches on my tree, but I was forced to remove,
> > as Grant rejected the patches. After his nack, lots of dicussions about
> > the DT bindings started and, until last week, there were no consensus
> > about that (as far as I followed the discussions).
> > 
> > So, reluctantly, I just dropped this series from my tree, pretending
> > it never existed, as reverting them could cause troubles if it 
> > (or some version of it) got merged via Greg, Grant and/or Russell
> > trees.
> > 
> > On my head, it become too late to merge it for 3.15, as first
> > people must agree on the DT bindings. Also, I already closed the
> > media merge window, as -rc7 seems to be the last -rc.
> > 
> > One possible approach for this would be to merge the patches that move
> > the OF graph code away from drivers/media, and the corresponding
> > internal ABI changes early at -rc, and applying the DT binding
> > patches, and the staging imx-drm driver for 3.16.
> 
> I don't understand, was I supposed to do something in my staging-next
> tree for this as well?
> 
> totally confused,

Hi Greg,

Let me summarize what was discussed so far with regards to it.

There are two changesets related to this:
- a 6 patch series moving OF graph functions from
  /drivers/media to /drivers/of;
- a 12 patch series (at version 11 - not sure if are there any
  newer version) that adds the imx-drm driver to staging.

At the first series, there's one DT patch in the middle.

Both patch series was being discussed for a while at the
pertinent MLs.

My understanding on March, 7, after an email from Russell,
was that everybody was happy with the first patch series, 
and that I should be applying it on my tree. So, I did it.

However, on the same day, Grant nacked the patch series,
because of some DT bindings, mainly focused on this one:
	"Documentation: of: Document graph bindings"

After lots of discussions and no agreements with regards
to it, Grant asked me to rewind my git tree, in order to
discard the git pull from the first series.

Even hating the idea of doing a git rebase upstream, 
after talking with the media submaintainers on IRC,
I did a git rewind, as I was afraid that just reverting
the 6 individual patches would cause merge conflicts with
other trees that might have merged those patches, or some
newer version of it.

Latter, Laurent also rised some other points about for the
DT binding discussions, and, AFAICT, there's still no
consensus about that.

In the mean time, it seems you applied those 6 patches on your 
staging tree - at least, I received 6 messages from you about
those commits. Also, as this conflict arrived at -next, I
suspect that those patches are still on your tree.

Please notice that, from my side, I don't have anything
against those patch series, as the changes on the media 
drivers are just at the ABI glue, and I already acked with
those changes. 

The only thing that concerns me is that, if this series gets applied
upstream, the patch that Stephen did will needed to be applied
upstream to, to avoid compilation breakages there due to the 
Exynos patches on my tree that depend on the current ABI.

Regards,
Mauro
> 
> greg k-h




Regards,
Mauro
