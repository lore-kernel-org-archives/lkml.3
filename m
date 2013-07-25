Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab3GYXH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:07:59 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:59535 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756796Ab3GYXH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:07:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 26 Jul 2013 00:06:17 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] drm/i915: split PCI IDs out into i915_drm.h v3
Message-ID: <20130725230617.GE13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
	torvalds@linux-foundation.org
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <1374770269-3223-2-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374770269-3223-2-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:37:48AM -0700, Jesse Barnes wrote:
> For use by userspace (at some point in the future) and other kernel code.
> 
> v2: move PCI IDs to uabi (Chris)
>     move PCI IDs to drm/ (Dave)
> v3: fixup Quanta detection - needs to come first (Daniel)

One last comment!

> +#define INTEL_VGA_DEVICE(id, info) {		\
> +	.class = PCI_BASE_CLASS_DISPLAY << 16,	\
> +	.class_mask = 0xff0000,			\
> +	.vendor = 0x8086,			\
> +	.device = id,				\
> +	.subvendor = PCI_ANY_ID,		\
> +	.subdevice = PCI_ANY_ID,		\
> +	.driver_data = (unsigned long) info }

libpciaccess doesn't define either PCI_BASE_CLASS_DISPLAY or PCI_ANY_ID.
Since we use the hex values for the rest of the elements, it would seem
to be tidier to also use 0x3 << 16 instead of PCI_BASE_CLASS_DISPLAY << 16.
I would leave PCI_ANY_ID as a symbolic value though.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
