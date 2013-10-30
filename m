Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3J3PpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:45:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3J3PpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:45:14 -0400
Date: Wed, 30 Oct 2013 17:44:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        aik@ozlabs.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
Message-ID: <20131030154443.GJ4651@redhat.com>
References: <20131029160019.22578.16409.stgit@bling.home>
 <20131029161322.22578.18997.stgit@bling.home>
 <20131030104029.GE4651@redhat.com>
 <1383143422.4097.170.camel@ul30vt.home>
 <20131030153338.GI4651@redhat.com>
 <527128D7.9070603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527128D7.9070603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:42:15PM +0100, Paolo Bonzini wrote:
> Il 30/10/2013 16:33, Gleb Natapov ha scritto:
> > > Hmm, ok.  In that case I can drop this patch and I think the rest just
> > > boils down to userspace use of the device.  I had been close()'ing the
> > > kvm device fd when all QEMU vfio devices are detached, but I can just as
> > > easily leave it open in case a new device is added later.  I'll send out
> > > a new series after doing some more review and testing.  Do you have any
> > > comments on the rest of the series?  Thanks,
> >
> > If I understand 4/4 correctly if there is VFIO device connected we
> > assume non coherent domain. How hard it would be to do proper checking
> > in this path series?
> 
> Yes, that's my understanding as well.  Is the performance impact measurable?
> 
We grant a guest permission to call wbinvd() needlessly.

--
			Gleb.
