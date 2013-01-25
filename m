Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3AYKO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:14:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3AYKO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:14:56 -0500
Date: Fri, 25 Jan 2013 15:44:48 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        aquini@redhat.com, mst@redhat.com, agl@us.ibm.com
Subject: Re: [RFC 2/2] virtio_balloon: add auto-ballooning support
Message-ID: <20130125101448.GG30483@amit.redhat.com>
References: <1355861850-2702-1-git-send-email-lcapitulino@redhat.com>
 <1355861850-2702-3-git-send-email-lcapitulino@redhat.com>
 <20130111204317.GB11436@amit.redhat.com>
 <20130114100501.603ce8a4@doriath.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114100501.603ce8a4@doriath.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 14 Jan 2013 [10:05:01], Luiz Capitulino wrote:
> On Sat, 12 Jan 2013 02:13:17 +0530
> Amit Shah <amit.shah@redhat.com> wrote:
> 
> > On (Tue) 18 Dec 2012 [18:17:30], Luiz Capitulino wrote:
> > > The auto-ballooning feature automatically performs balloon inflate or
> > > deflate based on host and guest memory pressure. This can help to
> > > avoid swapping or worse in both, host and guest.
> > > 
> > > Auto-ballooning has a host and a guest part. The host performs
> > > automatic inflate by requesting the guest to inflate its balloon
> > > when the host is facing memory pressure. The guest performs
> > > automatic deflate when it's facing memory pressure itself. It's
> > > expected that auto-inflate and auto-deflate will balance each
> > > other over time.
> > > 
> > > This commit implements the guest side of auto-ballooning.
> > > 
> > > To perform automatic deflate, the virtio_balloon driver registers
> > > a shrinker callback, which will try to deflate the guest's balloon
> > > on guest memory pressure just like if it were a cache. The shrinker
> > > callback is only registered if the host supports the
> > > VIRTIO_BALLOON_F_AUTO_BALLOON feature bit.
> > 
> > I'm wondering if guest should auto-deflate even when the AUTO_BALLOON
> > feature isn't supported by the host: if a guest is under pressure,
> > there's no way for it to tell the host and wait for the host to
> > deflate the balloon, so it may be beneficial to just go ahead and
> > deflate the balloon for all hosts.
> 
> I see two problems with this. First, this will automagically override
> balloon changes done by the user; and second, if we don't have the
> auto-inflate part and if the host starts facing memory pressure, VMs
> may start getting OOM.

Practically, though, at least for hosts and VMs managed by libvirt,
guests will be confined by cgroups so they don't exceed some
pre-defined quota.  Guests should always be assumed to be malicious
and / or greedy, so I'm certain all host mgmt software will have some
checks in place.

		Amit
