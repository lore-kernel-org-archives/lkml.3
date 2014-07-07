Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaGGRxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:53:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42157 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:53:53 -0400
Date: Mon, 7 Jul 2014 19:54:02 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to
 check devfn instead of check class type
Message-ID: <20140707175402.GS5821@phenom.ffwll.local>
Mail-Followup-To: Paolo Bonzini <pbonzini@redhat.com>,
	"Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
 <53A42DAA.80406@redhat.com>
 <53A692F9.3060200@intel.com>
 <53AA70C0.2000806@redhat.com>
 <20140707144917.GZ5821@phenom.ffwll.local>
 <53BAB569.5000709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BAB569.5000709@redhat.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 04:57:45PM +0200, Paolo Bonzini wrote:
> Il 07/07/2014 16:49, Daniel Vetter ha scritto:
> >So the correct fix to forward intel gpus to guests is indeed to somehow
> >fake the pch pci ids since the driver really needs them. Gross design, but
> >that's how the hardware works.
> 
> A way that could work for virtualization is this: if you find the card has a
> magic subsystem vendor id, fetch the subsystem device id and use _that_ as
> the PCH device id.
> 
> Would that work for you?

I guess for quemu it also depends upon what windows does since we can't
change that. If we care about that part. Another consideration is
supporting older kernels, if that's possible at all.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
