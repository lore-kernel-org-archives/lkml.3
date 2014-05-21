Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaEUUoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:44:14 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57422 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbaEUUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:44:13 -0400
Message-ID: <1400705051.30334.28.camel@x220>
Subject: Re: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
From: Paul Bolle <pebolle@tiscali.nl>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 22:44:11 +0200
In-Reply-To: <20140521202735.GC23153@alberich>
References: <1400602574.4912.43.camel@x220>
	 <20140521202735.GC23153@alberich>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2014 20:44:11.0390 (UTC) FILETIME=[6B79E1E0:01CF7535]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 22:27 +0200, Andreas Herrmann wrote:
> On Tue, May 20, 2014 at 06:16:14PM +0200, Paul Bolle wrote:
> > Three checks for CONFIG_CAVIUM_GDB were added in v2.6.29. But the
> > Kconfig symbol CAVIUM_GDB was never added to the tree. Remove these
> > checks.
> > 
> > Also remove the last reference to octeon_get_boot_debug_flag(). There is
> > no definition of that function anyway.
> 
> Hmm, yes, this was added with commit
> 5b3b16880f404ca54126210ca86141cceeafc0cf (MIPS: Add Cavium OCTEON
> processor support files to arch/mips/cavium-octeon.) and incomplete
> ever since (in mainline kernel).

I've decided not to mention the exact commits, and only mention
releases, if problems are rather old. Ie, v2.6.29 should mean, to most
observers, "a long time ago".
 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested.
> 
> Removing this dead code shouldn't harm. I also did a quick test of a
> kernel with your patch with an octeon system -- as expected no issues
> observed. (So it's
> Tested-by: Andreas Herrmann <andreas.herrmann@caviumnetworks.com>)

That's great, thanks!

> > A follow up might be to remove plat_smp_ops.cpus_done. All these
> > callbacks are now (basically) nops.
> 
> I am not sure about completely removing cpus_done from
> plat_smp_ops. Maybe some platform will really make use of this in the
> future.

My view is that cpus_done should just be re-added if that happens.


Paul Bolle

