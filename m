Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaGOO3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:29:44 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39559 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGOO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:29:40 -0400
Date: Tue, 15 Jul 2014 10:29:33 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140715142931.GA2485@gmail.com>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
 <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
 <019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
 <20140713035535.GB5301@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
 <20140713164901.GB10624@gmail.com>
 <53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 02:35:19PM +1000, Dave Airlie wrote:
> On 14 July 2014 18:37, Christian König <deathsimple@vodafone.de> wrote:
> >> I vote for HSA module that expose ioctl and is an intermediary with the
> >> kernel driver that handle the hardware. This gives a single point for
> >> HSA hardware and yes this enforce things for any hardware manufacturer.
> >> I am more than happy to tell them that this is it and nothing else if
> >> they want to get upstream.
> >
> > I think we should still discuss this single point of entry a bit more.
> >
> > Just to make it clear the plan is to expose all physical HSA capable devices
> > through a single /dev/hsa device node to userspace.
> 
> This is why we don't design kernel interfaces in secret foundations,
> and expect anyone to like them.
> 

I think at this time this is unlikely to get into 3.17. But Christian had
point on having multiple device file. So something like /dev/hsa/*

> So before we go any further, how is this stuff planned to work for
> multiple GPUs/accelerators?

My understanding is that you create queue and each queue is associated
with a device. You can create several queue for same device and have
different priority btw queue.

Btw queue here means a ring buffer that understand a common set of pm4
packet.

> Do we have a userspace to exercise this interface so we can see how
> such a thing would look?

I think we need to wait a bit before freezing and accepting the kernel
api and see enough userspace bits to be confortable. Moreover if AMD
wants common API for HSA i also think that they at very least needs
there HSA partner to make public comment on the kernel API.

Cheers,
Jérôme


