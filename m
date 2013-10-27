Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3J0TjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:39:25 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50377 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3J0TjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:39:24 -0400
Date: Mon, 28 Oct 2013 01:09:07 +0530
From: Afzal Mohammed <afzal.mohd.ma@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH RFC] kbuild: prevent git private tag altering
 kernelrelease
Message-ID: <20131027193907.GA2710@afzal-ThinkPad-R50e>
References: <1379109004-2411-1-git-send-email-afzal.mohd.ma@gmail.com>
 <5267CD3C.2020004@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267CD3C.2020004@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, Oct 23, 2013 at 03:21:00PM +0200, Michal Marek wrote:
> On 13.9.2013 23:49, Afzal Mohammed wrote:

> > If a private tag is created after the most recent kernelversion tag, a
> > commit after this private tag would feed kernelrelease with commits
> > after private tag and kernelversion tag. This may confuse user relying
> > on kernelrelease (mostly a developer while debugging), mainly if HEAD
> > has a private tag and otherwise w.r.t git distance from kernelversion
> > tag.
> 
> The solution is simple: Do not use private annotated tags. Or rather, if
> you are creating an annotated tag, modify EXTRAVERSION accordingly. Any
> automagic based on the tag name is going to fail in some way.

Here private tags, although not a proper term, (my description wasn't
clear) was referring to any annotated/signed tag that does not match
kernelversion.

Reason for this patch was to determine the exact source from kernel
logs easily while working over subystem maintainer trees (especially
useful when checking older logs and testing). More than my private tags,
it is the tags of subystem maintainers which never is a kernelversion
that made it difficult to determine the source from logs. Presence of
those tags misleads one about the source.

Modifying EXTRAVERSION would make it dirty, else commiting only for
the sake of avoiding dirty would be required to track the git source
and chances are high that git gc may eat those commits.

> With your change, the script considers e.g. the next-YYYYMMDD tags
> "private."

Although next tags were not causing much problem (due to
localversion-next file and as no direct development over next),
maintainer tags like this without localversion-* files were the ones
that was being mostly targeted by this change.

> >  define filechk_kernel.release
> > -	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
> > +	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree) $(KERNELVERSION))" > $@
> >  endef
> 
> The >$@ should not be there.

Yes, crap, happened while rebasing - punishment for coding without
proper understanding.

Regards
Afzal
