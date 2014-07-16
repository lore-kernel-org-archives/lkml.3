Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203AbaGPOyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:54:50 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:45423 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbaGPOys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:54:48 -0400
Date: Wed, 16 Jul 2014 10:52:56 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "Bridgman, John" <John.Bridgman@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140716145253.GA2770@gmail.com>
References: <20140713035535.GB5301@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
 <20140713164901.GB10624@gmail.com>
 <53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
 <20140715173704.GA3421@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
 <20140715180445.GB3421@gmail.com>
 <CAKMK7uEohJaiNCdDeV-6GNtH=0YSsw-o8V1zMYtOFEnkbOK+wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uEohJaiNCdDeV-6GNtH=0YSsw-o8V1zMYtOFEnkbOK+wA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:27:42AM +0200, Daniel Vetter wrote:
> On Tue, Jul 15, 2014 at 8:04 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> >> Yes although it can be skipped on most systems. We figured that topology
> >> needed to cover everything that would be handled by a single OS image, so
> >> in a NUMA system it would need to cover all the CPUs. I think that is still
> >> the right scope, do you agree ?
> >
> > I think it is a idea to duplicate cpu. I would rather have each device
> > give its afinity against each cpu and for cpu just keep the existing
> > kernel api that expose this through sysfs iirc.
> 
> It's all there already if we fix up the hsa dev-node model to expose
> one dev node per underlying device instead of one for everything:
> - cpus already expose the full numa topology in sysfs
> - pci devices have a numa_node file in sysfs to display the link
> - we can easily add similar stuff for platform devices on arm socs
> without pci devices.
> 
> Then the only thing userspace needs to do is follow the device link in
> the hsa instance node in sysfs and we have all the information
> exposed. Iff we expose one hsa driver instance to userspace per
> physical device (which is the normal linux device driver model
> anyway).
> 
> I don't see a need to add anything hsa specific here at all (well
> maybe some description of the cache architecture on the hsa device
> itself, the spec seems to have provisions for that).
> -Daniel

What is HSA specific is userspace command queue in form of common ring
buffer execution queue all sharing common packet format. So yes i see
a reason for an HSA class that provide common ioctl through one dev file
per device. Note that i am not a fan of userspace command queue given
that linux ioctl overhead is small and having kernel do stuff would
allow for really "infinite" number of userspace context while right
now limit is DOORBELL_APERTURE_SIZE/PAGE_SIZE.

No, CPU should not be included, neither should the numa topology of
device. And yes all numa topology should use existing kernel interface.
I however understand that a second GPU specific topology might make
sense ie if you have specialize link btw some discrete GPU.

So if Intel wants to join the HSA foundation fine, but unless you are
ready to implement what is needed i do not see the value of forcing
your wish on another group that is trying to standardize something.

Cheers,
Jérôme
