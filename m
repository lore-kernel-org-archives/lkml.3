Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3AOMAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:00:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58615 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3AOMAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:00:20 -0500
Date: Tue, 15 Jan 2013 12:00:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast receiver
Message-ID: <20130115120012.GA23333@e106331-lin.cambridge.arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
 <1357742770-15028-2-git-send-email-mark.rutland@arm.com>
 <alpine.LFD.2.02.1301141204421.7475@ionos>
 <20130114112951.GC7990@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1301141247020.7475@ionos>
 <20130114121247.GD7990@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1301141318460.7475@ionos>
 <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1301151224300.7475@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301151224300.7475@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Jan 2013 12:00:15.0965 (UTC) FILETIME=[E1AD70D0:01CDF317]
X-MC-Unique: 113011512001712701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:24:53AM +0000, Thomas Gleixner wrote:
> On Mon, 14 Jan 2013, Mark Rutland wrote:
> > On Mon, Jan 14, 2013 at 02:17:26PM +0000, Thomas Gleixner wrote:
> > > > I thought this previously also [1], but I couldn't find any path such that a
> > > > tick_cpu_device would have an evtdev without an event_handler. We always set the
> > > > handler before setting evtdev, and alway wipe evtdev before wiping the handler.
> > > > 
> > > > Have I missed something?
> > > 
> > > That's an x86 specific issue. Though we could try and make that
> > > functionality completely generic.
> > 
> > Just to check: is the evt->event_handler check necessary?
> 
> For x86 yes. See the comment.

Ah, sorry. I misunderstood on my initial reading.

I've posted a version with the evt->event_handler check restored, and the
tick_receive_broadcast stub removed when !CONFIG_GENERIC_CLOCKEVENTS_BROADCAST:

https://lkml.org/lkml/2013/1/14/276

The generic clockevents patches (based on v3.8-rc3) can also be found at
git://linux-arm.org/linux-mr.git tags/timer-broadcast-v3-core

> Thanks,
> 
> 	tglx
> 

Thanks,
Mark.

