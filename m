Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaKRLFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:05:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbaKRLFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:05:06 -0500
Date: Tue, 18 Nov 2014 13:04:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio: introduce methods of sanitizing device
 features
Message-ID: <20141118110454.GB21664@redhat.com>
References: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
 <20141117093701.GC20133@redhat.com>
 <20141117104430.54362e7d.cornelia.huck@de.ibm.com>
 <20141117101139.GE20133@redhat.com>
 <546ABBC5.7030603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546ABBC5.7030603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:23:49AM +0800, Jason Wang wrote:
> On 11/17/2014 06:11 PM, Michael S. Tsirkin wrote:
> > On Mon, Nov 17, 2014 at 10:44:30AM +0100, Cornelia Huck wrote:
> >> On Mon, 17 Nov 2014 11:37:01 +0200
> >> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>
> >>> On Mon, Nov 17, 2014 at 05:17:17PM +0800, Jason Wang wrote:
> >>>> Buggy host may advertised buggy host features (a usual case is that host
> >>>> advertise a feature whose dependencies were missed). In this case, driver
> >>>> should detect and disable the buggy features by itself.
> >>>>
> >>>> This patch introduces driver specific sanitize_features() method which is
> >>>> called just before features finalizing to detect and disable buggy features
> >>>> advertised by host.
> >>>>
> >>>> Virtio-net will be the first user.
> >>>>
> >>>> Cc: Rusty Russell <rusty@rustcorp.com.au>
> >>>> Cc: Michael S. Tsirkin <mst@redhat.com>
> >>>> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> >>>> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>> Hmm this conflicts with virtio 1.0 work: we drop
> >>> features as bitmap there.
> >> But that's an implementation detail, no? We'll still need a way for the
> >> driver to sanitize features, and I think this interface works just fine.
> > Now that you mention it, I don't think we do.
> >
> > The spec is quite explicit that devices must not expose invalid
> > combinations of features.
> >
> > Admittedly, BUG_ON isn't very friendly to hypervisors.
> >
> > But e.g. failing probe seems better than trying to work around
> > hypervisor bugs - otherwise we'll be stuck maintaining compatibility
> > with hypervisors forever.
> >
> 
> I'm ok with failing the probe.
> 
> But it won't cost big effort to workaround only features dependencies
> issue.

>From experience, second-guessing user always adds maintainance.

> I don't see how this block any further features implementation.
> Looking at virtio-net, it also depends on network core to fix NETIF_F_*
> dependencies.

That code is common for all drivers, so it was moved to core.

> There seems no way to get rid of maintaining compatibility, e.g  the
> workarounds for the buggy hypervisor without VIRTIO_F_ANY_LAYOUT support.

Right - because too many hypervisors shipped without it, it's too
much work to fix them all.
No such motivation here, right?

-- 
MST
