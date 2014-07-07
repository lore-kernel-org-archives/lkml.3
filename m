Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaGGOtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:49:12 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55146 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGGOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:49:10 -0400
Date: Mon, 7 Jul 2014 16:49:17 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Chen, Tiejun" <tiejun.chen@intel.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
Message-ID: <20140707144917.GZ5821@phenom.ffwll.local>
Mail-Followup-To: Paolo Bonzini <pbonzini@redhat.com>,
	"Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
 <53A42DAA.80406@redhat.com>
 <53A692F9.3060200@intel.com>
 <53AA70C0.2000806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA70C0.2000806@redhat.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:48:32AM +0200, Paolo Bonzini wrote:
> It is only slightly better, but the right solution is to fix the driver.
> There is absolutely zero reason why a graphics driver should know about the
> vendor/device ids of the PCH.

There is a very valid reason to know about the PCH since it _is_ part of
the gpu. You don't notice this all that much in the driver since the
hardware provides magic mmio regions in the main vga device register bar
which remap to the relevant PCH register ranges. And an awful lot of other
stuff like the MCH. So from an abstract pov you could only pass the intel
igt to a guest if you'd forward the gfx device, the mch/host bridge and
the pch. Thanks to these magic mmio windows we don't need those, except
that someone forgot to forward the pch pci id.

So the correct fix to forward intel gpus to guests is indeed to somehow
fake the pch pci ids since the driver really needs them. Gross design, but
that's how the hardware works.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
