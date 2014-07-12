Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaGLKM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 06:12:56 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57176 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaGLKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 06:12:52 -0400
Date: Sat, 12 Jul 2014 12:13:02 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Chen, Tiejun" <tiejun.chen@intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>
Subject: Re: [Intel-gfx] [Xen-devel] [RFC][PATCH]
 gpu:drm:i915:intel_detect_pch: back to check devfn instead of check class
 type
Message-ID: <20140712101302.GT17271@phenom.ffwll.local>
Mail-Followup-To: "Tian, Kevin" <kevin.tian@intel.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"airlied@linux.ie" <airlied@linux.ie>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"Chen, Tiejun" <tiejun.chen@intel.com>,
	"Kay, Allen M" <allen.m.kay@intel.com>
References: <53AA70C0.2000806@redhat.com>
 <20140707144917.GZ5821@phenom.ffwll.local>
 <53BAB569.5000709@redhat.com>
 <20140707175402.GS5821@phenom.ffwll.local>
 <53BADFC6.9060101@redhat.com>
 <20140707184006.GU5821@phenom.ffwll.local>
 <AADFC41AFE54684AB9EE6CBC0274A5D125FCA7FF@SHSMSX101.ccr.corp.intel.com>
 <20140711062956.GP17271@phenom.ffwll.local>
 <20140711194206.GI23257@laptop.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D125FCD743@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D125FCD743@SHSMSX101.ccr.corp.intel.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:30:59PM +0000, Tian, Kevin wrote:
> > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > Sent: Friday, July 11, 2014 12:42 PM
> > 
> > On Fri, Jul 11, 2014 at 08:29:56AM +0200, Daniel Vetter wrote:
> > > On Thu, Jul 10, 2014 at 09:08:24PM +0000, Tian, Kevin wrote:
> > > > actually I'm curious whether it's still necessary to __detect__ PCH. Could
> > > > we assume a 1:1 mapping between GPU and PCH, e.g. BDW already hard
> > > > code the knowledge:
> > > >
> > > >               } else if (IS_BROADWELL(dev)) {
> > > >                       dev_priv->pch_type = PCH_LPT;
> > > >                       dev_priv->pch_id =
> > > >
> > INTEL_PCH_LPT_LP_DEVICE_ID_TYPE;
> > > >                       DRM_DEBUG_KMS("This is Broadwell,
> > assuming "
> > > >                                     "LynxPoint LP PCH\n");
> > > >
> > > > Or if there is real usage on non-fixed mapping (not majority), could it be a
> > > > better option to have fixed mapping as a fallback instead of leaving as
> > > > PCH_NONE? Then even when Qemu doesn't provide a special tweaked
> > PCH,
> > > > the majority case just works.
> > >
> > > I guess we can do it, at least I haven't seen any strange combinations in
> > > the wild outside of Intel ...
> > 
> > How big is the QA matrix for this? Would it make sense to just
> > include the latest hardware (say going two generations back)
> > and ignore the older one?
> 
> suppose minimal or no QA effort on bare metal, if we only conservatively 
> change the fallback path which is today not supposed to function with 
> PCH_NONE. so it's only same amount of QA effort as whatever else is 
> proposed in this passthru upstreaming task. I agree no need to cover 
> older model, possibly just snb, ivb and hsw, but will leave Tiejun to answer 
> the overall goal.

Yeah, I'd be ok with the approach of using defaults if we can't recognize
the pch - if anyone screams we can either quirk or figure something else
out.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
