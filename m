Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3JAIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:25:55 -0400
Received: from ozlabs.org ([203.10.76.45]:42128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab3JAIZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:25:53 -0400
Date: Tue, 1 Oct 2013 18:25:48 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        gleb@redhat.com, pbonzini@redhat.com, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 2/3] hwrng: Add a driver for the hwrng found in power7+
 systems
Message-ID: <20131001082547.GA27484@concordia>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
 <1380177066-3835-2-git-send-email-michael@ellerman.id.au>
 <1380182487.28561.22.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380182487.28561.22.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 06:01:27PM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2013-09-26 at 16:31 +1000, Michael Ellerman wrote:
> 
> > +       pr_info("registered powernv hwrng.\n");
> 
> First letter of a line should get a capital :-) Also since
> it's per-device, at least indicate the OF path or the chip number or
> something ...

It's not the first letter, it looks like this:

  powernv-rng: registered powernv hwrng.

Which looks nice to me, but I can make it this if you prefer:

  powernv-rng: Registered powernv hwrng.


And it's not per-device due to the trick in the probe routine. It's a
bit sneaky but we need to make it a proper driver for module loading to
work, but we only want to register one hwrng device.

cheers
