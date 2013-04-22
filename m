Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3DVVmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:42:07 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59340 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3DVVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:42:05 -0400
Date: Mon, 22 Apr 2013 14:41:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora@gmail.com,
        dhaval.giani@gmail.com, Kay Sievers <kay.sievers@vrfy.org>,
        jpoimboe@redhat.com, "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter@redhat.com, workman-devel@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130422214159.GG12543@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tim.

On Mon, Apr 22, 2013 at 11:26:48PM +0200, Tim Hockin wrote:
> We absolutely depend on the ability to split cgroup hierarchies.  It
> pretty much saved our fleet from imploding, in a way that a unified
> hierarchy just could not do.  A mandated unified hierarchy is madness.
>  Please step away from the ledge.

You need to be a lot more specific about why unified hierarchy can't
be implemented.  The last time I asked around blk/memcg people in
google, while they said that they'll need different levels of
granularities for different controllers, google's use of cgroup
doesn't require multiple orthogonal classifications of the same group
of tasks.

Also, cgroup isn't dropping multiple hierarchy support over-night.
What has been working till now will continue to work for very long
time.  If there is no fundamental conflict with the future changes,
there should be enough time to migrate gradually as desired.

> More, going towards a unified hierarchy really limits what we can
> delegate, and that is the word of the day.  We've got a central
> authority agent running which manages cgroups, and we want out of this
> business.  At least, we want to be able to grant users a set of
> constraints, and then let them run wild within those constraints.
> Forcing all such work to go through a daemon has proven to be very
> problematic, and it has been great now that users can have DIY
> sub-cgroups.

Sorry, but that doesn't work properly now.  It gives you the illusion
of proper delegation but it's inherently dangerous.  If that sort of
illusion has been / is good enough for your setup, fine.  Delegate at
your own risks, but cgroup in itself doesn't support delegation to
lesser security domains and it won't in the foreseeable future.

> Strong disagreement, here.  We use split hierarchies to great effect.
> Containment should be composable.  If your users or abstractions can't
> handle it, please feel free to co-mount the universe, but please
> PLEASE don't force us to.
> 
> I'm happy to talk more about what we do and why.

Please do so.  Why do you need multiple orthogonal hierarchies?

Thanks.

-- 
tejun
