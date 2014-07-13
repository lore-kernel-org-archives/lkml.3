Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaGMQkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:40:45 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33588 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaGMQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:40:38 -0400
Date: Sun, 13 Jul 2014 12:40:32 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140713164030.GA10624@gmail.com>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
 <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
 <53C0FEE1.50206@amd.com>
 <20140712111032.GV17271@phenom.ffwll.local>
 <20140712164928.GA5301@gmail.com>
 <CAKMK7uEfccyxzEy3HvAqJEZWWF6-brf81EmBEg47xtrhCT_txA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uEfccyxzEy3HvAqJEZWWF6-brf81EmBEg47xtrhCT_txA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:42:58AM +0200, Daniel Vetter wrote:
> On Sat, Jul 12, 2014 at 6:49 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> >> Hm, so the hsa part is a completely new driver/subsystem, not just an
> >> additional ioctl tacked onto radoen? The history of drm is littered with
> >> "generic" ioctls that turned out to be useful for exactly one driver.
> >> Which is why _all_ the command submission is now done with driver-private
> >> ioctls.
> >>
> >> I'd be quite a bit surprised if that suddenly works differently, so before
> >> we bless a generic hsa interface I really want to see some implementation
> >> from a different vendor (i.e. nvdidia or intel) using the same ioctls.
> >> Otherwise we just repeat history and I'm not terribly inclined to keep on
> >> cleanup up cruft forever - one drm legacy is enough ;-)
> >>
> >> Jesse is the guy from our side to talk to about this.
> >> -Daniel
> >
> > I am not worried about that side, the hsa foundation has pretty strict
> > guidelines on what is hsa compliant hardware ie the hw needs to understand
> > the pm4 packet format of radeon (well small subset of it). But of course
> > this require hsa compliant hardware and from member i am guessing ARM Mali,
> > ImgTech, Qualcomm, ... so unless Intel and NVidia joins hsa you will not
> > see it for those hardware.
> >
> > So yes for once same ioctl would apply to different hardware. The only things
> > that is different is the shader isa. The hsafoundation site has some pdf
> > explaining all that but someone thought that slideshare would be a good idea
> > personnaly i would not register to any of the website just to get the pdf.
> >
> > So to sumup i am ok with having a new device file that present uniform set
> > of ioctl. It would actualy be lot easier for userspace, just open this fix
> > device file and ask for list of compliant hardware.
> >
> > Then radeon kernel driver would register itself as a provider. So all ioctl
> > decoding marshalling would be share which makes sense.
> 
> There's also the other side namely that preparing the cp ring in
> userspace and submitting the entire pile through a doorbell to the hw
> scheduler isn't really hsa exclusive. And for a solid platform with
> seamless gpu/cpu integration that means we need standard ways to set
> gpu context priorities and get at useful stats like gpu time used by a
> given context.
> 
> To get there I guess intel/nvidia need to reuse the hsa subsystem with
> the command submission adjusted a bit. Kinda like drm where kms and
> buffer sharing is common and cs driver specific.

HSA module would be for HSA compliant hardware and thus hardware would
need to follow HSA specification which again is pretty clear on what
the hardware need to provide. So if Intel and NVidia wants to join HSA
i am sure they would be welcome, the more the merrier :)

So i would not block HSA kernel ioctl design in order to please non HSA
hardware especialy if at this point in time nor Intel or NVidia can
share anything concret on the design and how this things should be setup
for there hardware.

When Intel or NVidia present their own API they should provide their
own set of ioctl through their own platform.

Cheers,
Jérôme Glisse
