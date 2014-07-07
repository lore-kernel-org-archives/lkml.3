Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaGGOvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:51:33 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:44321 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaGGOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:51:14 -0400
Date: Mon, 7 Jul 2014 16:51:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Chen, Tiejun" <tiejun.chen@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to
 check devfn instead of check class type
Message-ID: <20140707145120.GA5821@phenom.ffwll.local>
Mail-Followup-To: "Chen, Tiejun" <tiejun.chen@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>, jani.nikula@linux.intel.com,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
 <20140624025944.GJ1045@zhen-hp.sh.intel.com>
 <53AA33C5.7060501@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA33C5.7060501@intel.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:28:21AM +0800, Chen, Tiejun wrote:
> On 2014/6/24 10:59, Zhenyu Wang wrote:
> >On 2014.06.19 17:53:51 +0800, Tiejun Chen wrote:
> >>Originally the reason to probe ISA bridge instead of Dev31:Fun0
> >>is to make graphics device passthrough work easy for VMM, that
> >>only need to expose ISA bridge to let driver know the real
> >>hardware underneath. This is a requirement from virtualization
> >>team. Especially in that virtualized environments, XEN, there
> >>is irrelevant ISA bridge in the system with that legacy qemu
> >>version specific to xen, qemu-xen-traditional. So to work
> >>reliably, we should scan through all the ISA bridge devices
> >>and check for the first match, instead of only checking the
> >>first one.
> >>
> >>But actually, qemu-xen-traditional, is always enumerated with
> >>Dev31:Fun0, 00:1f.0 as follows:
> >>
> >>hw/pt-graphics.c:
> >>
> >>intel_pch_init()
> >>     |
> >>     + pci_isa_bridge_init(bus, PCI_DEVFN(0x1f, 0), ...);
> >>
> >>so this mean that isa bridge is still represented with Dev31:Func0
> >>like the native OS. Furthermore, currently we're pushing VGA
> >>passthrough support into qemu upstream, and with some discussion,
> >>we wouldn't set the bridge class type and just expose this devfn.
> >>
> >>So we just go back to check devfn to make life normal.
> >>
> >>Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
> >
> >This was added historically when supporting graphics device passthrough.
> >Looks qemu upstream can't accept multiple ISA bridge and our PCH is always
> >on device 31: func0 as far as I know. Looks good to me.
> >
> >Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> >
> 
> Thanks for your review.
> 
> Do you know when this can be applied?

I'll hold off merging until we have buy-in from upstream quemu on a given
approach (which should work for both linux and windows).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
