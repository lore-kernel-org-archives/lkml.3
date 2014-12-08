Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaLHKUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:20:20 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51495 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaLHKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:20:17 -0500
Date: Mon, 8 Dec 2014 11:20:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        linux-kernel@vger.kernel.org, "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
Message-ID: <20141208102049.GO20350@phenom.ffwll.local>
Mail-Followup-To: Gerd Hoffmann <kraxel@redhat.com>,
	Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
	"White, Michael L" <michael.l.white@intel.com>,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"Li, Susie" <susie.li@intel.com>,
	"Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
	linux-kernel@vger.kernel.org,
	"Haron, Sandra" <sandra.haron@intel.com>
References: <547FC5DE.4010701@intel.com>
 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
 <5482835F.5090707@intel.com>
 <1418032501.27021.42.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418032501.27021.42.camel@nilsson.home.kraxel.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:55:01AM +0100, Gerd Hoffmann wrote:
> On Sa, 2014-12-06 at 12:17 +0800, Jike Song wrote:
> > I don't know that is exactly needed, we also need to have Windows
> > driver considered.  However, I'm quite confident that, if things gonna
> > work for IGD passthrough, it gonna work for GVT-g.
> 
> I'd suggest to focus on q35 emulation.  q35 is new enough that a version
> with integrated graphics exists, so the gap we have to close is *much*
> smaller.
> 
> In case guests expect a northbridge matching the chipset generation of
> the graphics device (which I'd expect is the case, after digging a bit
> in the igd and agpgart linux driver code) I think we should add proper
> device emulation for them, i.e. comply q35-pcihost with
> sandybridge-pcihost + ivybridge-pcihost + haswell-pcihost instead of
> just copying over the pci ids from the host.  Most likely all those
> variants can share most of the emulation code.

I don't think i915.ko should care about either northbridge nor pch on
para-virtualized platforms. We do noodle around in there for the oddball
memory controller setting and for some display stuff. But neither of that
really applies to paravirtualized hw. And if there's any case like that we
should  patch it out (like we do with some of the runtime pm code
already).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
