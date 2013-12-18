Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3LRXk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:40:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50884 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3LRXk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:40:56 -0500
Date: Wed, 18 Dec 2013 15:40:50 -0800
From: josh@joshtriplett.org
To: David Miller <davem@davemloft.net>
Cc: richardcochran@gmail.com, rashika.kheria@gmail.com,
        linux-kernel@vger.kernel.org, dvhart@linux.intel.com, joe@perches.com,
        andriy.shevchenko@linux.intel.com, vfalico@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: ptp: Include new header file in ptp_pch.c
Message-ID: <20131218234050.GA25482@cloud>
References: <1387140255-11797-1-git-send-email-rashika.kheria@gmail.com>
 <20131216085839.GA8303@netboy>
 <20131218.174359.2230195267384857675.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218.174359.2230195267384857675.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 05:43:59PM -0500, David Miller wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> Date: Mon, 16 Dec 2013 09:58:40 +0100
> 
> > On Mon, Dec 16, 2013 at 02:14:15AM +0530, Rashika Kheria wrote:
> >> ---
> >>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |    9 ---------
> >>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    1 +
> >>  drivers/ptp/ptp_pch.c                              |    1 +
> >>  include/linux/ptp_pch.h                            |   16 ++++++++++++++++
> >>  4 files changed, 18 insertions(+), 9 deletions(-)
> >>  create mode 100644 include/linux/ptp_pch.h
> > 
> > Instead of adding a random driver header into include/linux, I would
> > prefer that you just move the ptp_pch.c from drivers/ptp to
> > drivers/net/ethernet/oki-semi/pch_gbe. Then you can just include
> > pch_gbe.h directly.
> 
> I think this begs an even more fundamental question, why isn't the PTP
> driver abstraction providing the necessary methods and interfaces so
> that pch_gbe doesn't have to call into the ptp_pch.c code directly?
> 
> Moving ptp_pch.c elsehwere is not desirable, it's a PTP driver so
> it belongs under drivers/ptp.

For the moment, at least, would it be reasonable to have a proper header
for these functions since pch_gbe is currently calling them?  Making
that driver *not* call those functions might well be a sensible cleanup,
but does fixing this issue need to wait for that cleanup to happen?

- Josh Triplett
