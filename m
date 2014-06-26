Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaFZLbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:31:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:24877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998AbaFZLbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,552,1400050800"; 
   d="scan'208";a="534448236"
Message-ID: <1403782263.20275.59.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Dave Chinner <david@fromorbit.com>, Thomas Knauth <thomas.knauth@gmx.de>,
        David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 14:31:03 +0300
In-Reply-To: <53ABF7C4.1000906@itwm.fraunhofer.de>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
		 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
		 <1403677528.7903.103.camel@sauron.fi.intel.com>
		 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
		 <20140626010606.GT4453@dastard>
	 <1403763199.20275.39.camel@sauron.fi.intel.com>
	 <53ABF7C4.1000906@itwm.fraunhofer.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 12:36 +0200, Bernd Schubert wrote:
> On 06/26/2014 08:13 AM, Artem Bityutskiy wrote:
> > On Thu, 2014-06-26 at 11:06 +1000, Dave Chinner wrote:
> >> Your particular use case can be handled by directing your benchmark
> >> at a filesystem mount point and unmounting the filesystem in between
> >> benchmark runs. There is no ned to adding kernel functionality for
> >> somethign that can be so easily acheived by other means, especially
> >> in benchmark environments where *everything* is tightly controlled.
> >
> > If I was a benchmark writer, I would not be willing running it as root
> > to be able to mount/unmount, I would not be willing to require the
> > customer creating special dedicated partitions for the benchmark,
> > because this is too user-unfriendly. Or do I make incorrect assumptions?
> 
> But why a sysctl then? And also don't see a point for that at all, why 
> can't the benchmark use posix_fadvise(POSIX_FADV_DONTNEED)?

The latter question was answered - people want a way to drop caches for
a file. They need a method which guarantees that the caches are dropped.
They do not need an advisory method which does not give any guarantees.

As for the first question - this was what I was also asking too, but
without suggesting alternatives. I challenged the authors with the
following:

1. Why the interface would only allow the super user dropping the
caches? How about allowing the file owner or, generally speaking, the
person who is allowed to modify the file, drop the caches?

I alluded that this may be doable with an fd-based interface.

2. What about symlinks? Can I have a choice whether I drop caches
(struct inode, I suppose) for the symlink itself or for the destination
file? Again, fd-based interface would probably naturally allow for this.

3. What about leaving some room for future extensions? E.g., someone may
want to drop only part of a file in the future, who knows. Can we invent
an interface which would allow to be extended in the future, without
breaking older software?

My intention was to encourage the submitter to take some time and come
back with deeper analysis.

And finally, and most importantly, Dave stated that any per-file cache
dropping interface is unlikely going to be accepted at all, because
there is mount/unmount.

So far this is the mane concern the submitter should address.

But I just answered that what Dave suggested is probably not the nicest
way to do this from the user-space perspective, because it requires
superuser privileges, and probably a separate "benchmark-only"
partition.

So if the authors want to sell this new interface (in whatever form) to
the kernel community, they should start with providing a solid use-case,
with some more details, explore alternatives and show how the
alternatives do not work for them.

-- 
Best Regards,
Artem Bityutskiy

