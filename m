Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaAHJZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:25:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43372 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbaAHJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:25:26 -0500
Date: Wed, 8 Jan 2014 09:25:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Brown <broonie@kernel.org>, John Garry <john.garry@broadcom.com>
Subject: Re: [PATCH 3.10 126/129] clocksource: arch_timer: use virtual
 counters
Message-ID: <20140108092512.GA6701@e106331-lin.cambridge.arm.com>
References: <20140106223859.589799655@linuxfoundation.org>
 <20140106223903.201063932@linuxfoundation.org>
 <20140107100950.GA2930@e106331-lin.cambridge.arm.com>
 <20140107185040.GB4223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107185040.GB4223@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 06:50:40PM +0000, Greg Kroah-Hartman wrote:
> On Tue, Jan 07, 2014 at 10:09:50AM +0000, Mark Rutland wrote:
> > Hi Greg,
> > 
> > On Mon, Jan 06, 2014 at 10:39:15PM +0000, Greg Kroah-Hartman wrote:
> > > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This patch alone may break ARM systems booted at hyp mode or when KVM is
> > in use, causing CPUs to have different views of time or for a given
> > CPU's view of time to jump backwards.
> > 
> > The following two commits in mainline fix those two problems by ensuring
> > all CPUs have the same virtual timer offset (zero), and maintaining it
> > across KVM world switches. On arm64 the requisite CNTVOFF zeroing is
> > already present in linux-3.10.y.
> > 
> > 0af0b189abf7 (ARM: hyp: initialize CNTVOFF to zero)
> > f793c23ebbe5 (ARM: KVM: arch_timers: zero CNTVOFF upon return to host)
> 
> Thanks, I've now queued up both of these patches as well.  With that, we
> should be ok, right?

Cheers. I believe that should be sufficient, yes.

Mark.
