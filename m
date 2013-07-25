Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3GYWn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:43:56 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:58713 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757240Ab3GYWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:43:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 23:42:15 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] x86: add early quirk for reserving Intel graphics
 stolen memory v3
Message-ID: <20130725224006.GC13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
	torvalds@linux-foundation.org
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:37:49AM -0700, Jesse Barnes wrote:
> Systems with Intel graphics controllers set aside memory exclusively for
> gfx driver use.  This memory is not marked in the E820 as reserved or as
> RAM, and so is subject to overlap from E820 manipulation later in the
> boot process.  On some systems, MMIO space is allocated on top, despite
> the efforts of the "RAM buffer" approach, which simply rounds memory
> boundaries up to 64M to try to catch space that may decode as RAM and so
> is not suitable for MMIO.
> 
> v2: use read_pci_config for 32 bit reads instead of adding a new one
>     (Chris)
>     add gen6 stolen size function (Chris)
>     use a function pointer (Chris)
>     drop gen2 bits (Daniel)

As a reminder, can you please reorder the entries in the macro to ease
compilation by userspace - c++ doesn't like having .class and so I have
to massage the file with

intel_pciids.h: i915_pciids.h
       sed 's/_I915_PCIIDS/INTEL_PCIIDS/; s/\..*= //' < $^ > $@

to strip out the C99-style struct declarations (as my cpp skills were
obviously not strong enough) but then that requires the member ordering
is correct. Alternatively, if we discard the clean C99 code, both the
kernel struct pci_device_id and libpciaccess's struct pci_match_data are
the same - and I can just use i915_pciids.h directly. My perference is
to keep using C99 in the kernel as it makes the header much more
readable.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
