Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaAGSuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:50:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaAGSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:50:13 -0500
Date: Tue, 7 Jan 2014 10:50:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Brown <broonie@kernel.org>, John Garry <john.garry@broadcom.com>
Subject: Re: [PATCH 3.10 126/129] clocksource: arch_timer: use virtual
 counters
Message-ID: <20140107185040.GB4223@kroah.com>
References: <20140106223859.589799655@linuxfoundation.org>
 <20140106223903.201063932@linuxfoundation.org>
 <20140107100950.GA2930@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107100950.GA2930@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:09:50AM +0000, Mark Rutland wrote:
> Hi Greg,
> 
> On Mon, Jan 06, 2014 at 10:39:15PM +0000, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch alone may break ARM systems booted at hyp mode or when KVM is
> in use, causing CPUs to have different views of time or for a given
> CPU's view of time to jump backwards.
> 
> The following two commits in mainline fix those two problems by ensuring
> all CPUs have the same virtual timer offset (zero), and maintaining it
> across KVM world switches. On arm64 the requisite CNTVOFF zeroing is
> already present in linux-3.10.y.
> 
> 0af0b189abf7 (ARM: hyp: initialize CNTVOFF to zero)
> f793c23ebbe5 (ARM: KVM: arch_timers: zero CNTVOFF upon return to host)

Thanks, I've now queued up both of these patches as well.  With that, we
should be ok, right?

greg k-h
