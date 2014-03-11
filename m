Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaCKTU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:20:57 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38721 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbaCKTUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:20:55 -0400
X-Originating-IP: 98.158.13.34
Date: Tue, 11 Mar 2014 12:20:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, virtio-dev@lists.oasis-open.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: mmotm 2014-03-10-15-35 uploaded (virtio_balloon)
Message-ID: <20140311192046.GA2686@leaf>
References: <20140310223701.0969C31C2AA@corp2gmr1-1.hot.corp.google.com>
 <531F43F2.1030504@infradead.org>
 <20140311110338.333e1ee691cadb0f20dbb083@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311110338.333e1ee691cadb0f20dbb083@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:03:38AM -0700, Andrew Morton wrote:
> On Tue, 11 Mar 2014 10:12:18 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> > On 03/10/2014 03:37 PM, akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2014-03-10-15-35 has been uploaded to
> > > 
> > >    http://www.ozlabs.org/~akpm/mmotm/
> > > 
> > > mmotm-readme.txt says
> > > 
> > > README for mm-of-the-moment:
> > > 
> > > http://www.ozlabs.org/~akpm/mmotm/
> > > 
> > > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > > more than once a week.
> > > 
> > > You will need quilt to apply these patches to the latest Linus release (3.x
> > > or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > > http://ozlabs.org/~akpm/mmotm/series
> > > 
> > > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> > > followed by the base kernel version against which this patch series is to
> > > be applied.
> > > 
> > > This tree is partially included in linux-next.  To see which patches are
> > > included in linux-next, consult the `series' file.  Only the patches
> > > within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
> > > linux-next.
> > > 
> > 
> > on x86_64:
> > 
> > ERROR: "balloon_devinfo_alloc" [drivers/virtio/virtio_balloon.ko] undefined!
> > ERROR: "balloon_page_enqueue" [drivers/virtio/virtio_balloon.ko] undefined!
> > ERROR: "balloon_page_dequeue" [drivers/virtio/virtio_balloon.ko] undefined!
> > 
> > when loadable module
> > 
> > or
> > 
> > virtio_balloon.c:(.text+0x1fa26): undefined reference to `balloon_page_enqueue'
> > virtio_balloon.c:(.text+0x1fb87): undefined reference to `balloon_page_dequeue'
> > virtio_balloon.c:(.text+0x1fdf1): undefined reference to `balloon_devinfo_alloc'
> > 
> > when builtin.
> 
> OK, thanks, I'll drop
> http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch

Sorry about that; I missed that case in my testing.  It always seems
strange that the dependency goes that way around.

With virtio-balloon being the one and only user of this API, would it be
reasonable to just only compile in balloon_compaction.o when
CONFIG_VIRTIO_BALLOON?

- Josh Triplett
