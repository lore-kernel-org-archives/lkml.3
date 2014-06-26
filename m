Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaFZBGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:06:24 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12752 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbaFZBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:06:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgGAJtwq1N5LEio/2dsb2JhbABYgw2rSwaZOgGBBxd1hAMBAQU6HCMQCAMYCSUPBQ0YAyETiC4DEL0cDYZRFxaFTYZ0giUHhEMFmFSBfI1ihgqDVCs
Date: Thu, 26 Jun 2014 11:06:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: dedekind1@gmail.com, David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
Message-ID: <20140626010606.GT4453@dastard>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
 <1403677528.7903.103.camel@sauron.fi.intel.com>
 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:25:05AM +0200, Thomas Knauth wrote:
> On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Plus some explanations WRT why proc-based interface and what would be
> > the alternatives, what if tomorrow we want to extend the functionality
> > and drop caches only for certain file range, is this only for regular
> > files or also for directories, why posix_fadvice(DONTNEED) is not
> > sufficient.
> 
> I suggested the idea originally. Let me address each of your questions in turn:
> 
> Why a selective drop? To have a middle ground between echo 2 >
> drop_caches and echo 3 > drop_caches. When is this interesting? My
> particular use case was benchmarking. I wanted to repeatedly measure
> the timing when things were read from disk. Dropping everything from
> the cache, also drops useful things, not just the few files your
> benchmark intends to measure.

We're not likely to ever extend the drop_caches functionality. This
is brought up semi-regularly by people that have some slightly
narrower use-case for dropping caches.

Your particular use case can be handled by directing your benchmark
at a filesystem mount point and unmounting the filesystem in between 
benchmark runs. There is no ned to adding kernel functionality for
somethign that can be so easily acheived by other means, especially
in benchmark environments where *everything* is tightly controlled.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
