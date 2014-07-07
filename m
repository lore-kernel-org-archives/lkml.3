Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaGGSj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:39:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65483 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGGSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:39:57 -0400
Date: Mon, 7 Jul 2014 20:40:06 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to
 check devfn instead of check class type
Message-ID: <20140707184006.GU5821@phenom.ffwll.local>
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
 <20140707175402.GS5821@phenom.ffwll.local>
 <53BADFC6.9060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BADFC6.9060101@redhat.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 07:58:30PM +0200, Paolo Bonzini wrote:
> Il 07/07/2014 19:54, Daniel Vetter ha scritto:
> >On Mon, Jul 07, 2014 at 04:57:45PM +0200, Paolo Bonzini wrote:
> >>Il 07/07/2014 16:49, Daniel Vetter ha scritto:
> >>>So the correct fix to forward intel gpus to guests is indeed to somehow
> >>>fake the pch pci ids since the driver really needs them. Gross design, but
> >>>that's how the hardware works.
> >>
> >>A way that could work for virtualization is this: if you find the card has a
> >>magic subsystem vendor id, fetch the subsystem device id and use _that_ as
> >>the PCH device id.
> >>
> >>Would that work for you?
> >
> >I guess for quemu it also depends upon what windows does since we can't
> >change that. If we care about that part. Another consideration is
> >supporting older kernels, if that's possible at all.
> 
> Yes, but right now it's more important to get something that's not too gross
> for the future, for both Linux and Windows.  Hacks for existing guests can
> be done separately, especially since they might differ between Linux (check
> ISA bridge) and Windows (check 1f.0).

Well old Linux also checked 1f.0, so kinda the same really. As long as
1f.0 is an isa bridge. Wrt Windows I don't really expect them to change
this (they're probably more focuesed on the windows hypervisor or whatever).

In the end if the approach is ok for quemu and isn't much worse than what
we currently have I don't mind at all about the i915.ko code. I just want
to avoid flip-flopping around on the hack du jour like we seem to do just
now.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
