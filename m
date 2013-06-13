Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3FMC4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:56:31 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:44477 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab3FMC43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:56:29 -0400
Date: Wed, 12 Jun 2013 19:56:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Message-ID: <20130613025623.GB7432@mtj.dyndns.org>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
 <20130613023831.GB10979@localhost>
 <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
 <20130613024310.GC10979@localhost>
 <20130613024859.GA7432@mtj.dyndns.org>
 <20130613025202.GD10979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613025202.GD10979@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:52:02PM -0700, Kent Overstreet wrote:
> On Wed, Jun 12, 2013 at 07:48:59PM -0700, Tejun Heo wrote:
> > On Wed, Jun 12, 2013 at 07:43:10PM -0700, Kent Overstreet wrote:
> > > list_del() does do poisoning - and list debugging is cheaper to enable
> > > than full slab debugging.
> > 
> > Ah, right, now we have DEBUG_LIST.  Completely forgot about that.  I
> > don't think the cost difference matters that much as long as there are
> > enough people running with slab debugging, but, yeah, with DEBUG_LIST,
> > leaving list_del() alone would actually be better.  I'll drop that
> > part.
> 
> I can't remember if it was Fedora or RH (or both?) but in one of those
> they actually leave it enabled in their production kernels. Someone was
> blogging about the bugs it found...

And we poison regardless of DEBUG_LIST and looks like have been doing
that forever.  I have no idea why I was thinking list_del() didn't
poison.  Maybe it was something which got stuck in my brain from
before the git history or I'm just hallucinating.  Anyways, yeap,
list_del() is better.

Thanks.

-- 
tejun
