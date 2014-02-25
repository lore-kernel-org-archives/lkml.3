Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBYM3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:29:23 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50126 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbaBYM3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:29:21 -0500
Date: Tue, 25 Feb 2014 12:29:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-rt-users@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Ideas/suggestions to avoid repeated locking and reducing too
	many lists with dmaengine?
Message-ID: <20140225122916.GX27282@n2100.arm.linux.org.uk>
References: <530B9784.5060904@ti.com> <20140224192152.GV27282@n2100.arm.linux.org.uk> <530BC9F8.2040402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530BC9F8.2040402@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:38:48PM -0600, Joel Fernandes wrote:
> Actually I did do some tracing earlier before I posted this thread- and
> notice there was excessive traces of locking/unlocking. It is very light
> though as you pointed and lighter without debug options. The only other
> notable difference is the fact that we are now going through the dmaengine
> framework in the newer kernel vs the faster one.

Okay, for OMAP, there's additional latency caused by the tasklet which
starts a transaction when there's no previous transaction running -
that will be your biggest problem.

I do want to move omap-dma away from having a fixed binding between
claimed channels and the logical channels since that's too wasteful,
and that's what the tasklet will eventually be doing - but with
omap-dma being divorsed from the old code, this tasklet may not be
necessary anymore (since we no longer have to operate in process
context for that bit.)

There's a huge pile of patches I have queued up for the next merge
window in linux-next - I'd rather get these into mainline before
trying to do any restructuring, otherwise we're going to get into
a hell of a problem with merge conflicts.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
