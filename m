Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaGKTm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:42:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaGKTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:42:25 -0400
Date: Fri, 11 Jul 2014 15:42:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Chen, Tiejun" <tiejun.chen@intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>
Subject: Re: [Xen-devel] [Intel-gfx] [RFC][PATCH]
 gpu:drm:i915:intel_detect_pch: back to check devfn instead of check class
 type
Message-ID: <20140711194206.GI23257@laptop.dumpdata.com>
References: <53A42DAA.80406@redhat.com>
 <53A692F9.3060200@intel.com>
 <53AA70C0.2000806@redhat.com>
 <20140707144917.GZ5821@phenom.ffwll.local>
 <53BAB569.5000709@redhat.com>
 <20140707175402.GS5821@phenom.ffwll.local>
 <53BADFC6.9060101@redhat.com>
 <20140707184006.GU5821@phenom.ffwll.local>
 <AADFC41AFE54684AB9EE6CBC0274A5D125FCA7FF@SHSMSX101.ccr.corp.intel.com>
 <20140711062956.GP17271@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711062956.GP17271@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:29:56AM +0200, Daniel Vetter wrote:
> On Thu, Jul 10, 2014 at 09:08:24PM +0000, Tian, Kevin wrote:
> > actually I'm curious whether it's still necessary to __detect__ PCH. Could
> > we assume a 1:1 mapping between GPU and PCH, e.g. BDW already hard
> > code the knowledge:
> > 
> >               } else if (IS_BROADWELL(dev)) {
> >                       dev_priv->pch_type = PCH_LPT;
> >                       dev_priv->pch_id =
> >                               INTEL_PCH_LPT_LP_DEVICE_ID_TYPE;
> >                       DRM_DEBUG_KMS("This is Broadwell, assuming "
> >                                     "LynxPoint LP PCH\n");
> > 
> > Or if there is real usage on non-fixed mapping (not majority), could it be a 
> > better option to have fixed mapping as a fallback instead of leaving as 
> > PCH_NONE? Then even when Qemu doesn't provide a special tweaked PCH,
> > the majority case just works.
> 
> I guess we can do it, at least I haven't seen any strange combinations in
> the wild outside of Intel ...

How big is the QA matrix for this? Would it make sense to just
include the latest hardware (say going two generations back)
and ignore the older one?
