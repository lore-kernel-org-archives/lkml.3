Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3AaUBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab3AaUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:01:01 -0500
Date: Thu, 31 Jan 2013 22:00:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>,
        alex.williamson@redhat.com
Subject: Re: [PATCH] x86, x2apic: Only WARN on broken BIOSes inside a virtual
 guest
Message-ID: <20130131200024.GB1757@redhat.com>
References: <1359650435-73586-1-git-send-email-dzickus@redhat.com>
 <20130131185200.GA1757@redhat.com>
 <20130131193427.GP98867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131193427.GP98867@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 02:34:27PM -0500, Don Zickus wrote:
> On Thu, Jan 31, 2013 at 08:52:00PM +0200, Gleb Natapov wrote:
> > > http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf
> > > 
> > > After talking with folks, the threat of irq injections on virtual guests
> > > made sense.  However, when discussing if this was possible on bare metal
> > > machines, we could not come up with a plausible scenario.
> > > 
> > The irq injections is something that a guest with assigned device does
> > to attack a hypervisor it runs on. Interrupt remapping protects host
> > from this attack. According to pdf above if x2apic is disabled in a
> > hypervisor interrupt remapping can be bypassed and leave host vulnerable
> > to guest attack. This means that situation is exactly opposite: warning
> > has sense on a bare metal, but not in a guest. I am not sure that there is
> > a hypervisor that emulates interrupt remapping device though and without
> > it the warning cannot be triggered in a guest.
> 
> Ah, it makes sense.  Not sure how I got it backwards then.  So my patch is
> pointless then?  I'll asked for it to be dropped.
Yes, it is backwards.

> 
> >From my previous discussions with folks, is that KVM was protected from
> this type of attack.  Is that still true?
> 
Copying Alex. He said that to use device assignment without interrupt
remapping customer needs to opt-in explicitly. Not sure what happens
with interrupt remapping but with x2apic disabled.

The problem is not limited to virtualization BTW. Any vfio user may
attack kernel without interrupt remapping so vfio has the same opt-in.
 
--
			Gleb.
