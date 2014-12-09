Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaLICwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:52:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:63214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbaLICwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:52:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,542,1413270000"; 
   d="scan'208";a="620756911"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, Gerd Hoffmann <kraxel@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>
Subject: RE: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
Thread-Topic: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of
 Intel GVT-g(full GPU virtualization) for KVM
Thread-Index: AQHQEs0PR9sn/FTTFEy+ONRxxlNBGJyE9Y+AgAGaYuA=
Date: Tue, 9 Dec 2014 02:51:11 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D126113680@SHSMSX101.ccr.corp.intel.com>
References: <547FC5DE.4010701@intel.com>
 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
 <5482835F.5090707@intel.com>
 <1418032501.27021.42.camel@nilsson.home.kraxel.org>
 <20141208102049.GO20350@phenom.ffwll.local>
In-Reply-To: <20141208102049.GO20350@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB92qBtt029291

> From: Daniel Vetter
> Sent: Monday, December 08, 2014 6:21 PM
> 
> On Mon, Dec 08, 2014 at 10:55:01AM +0100, Gerd Hoffmann wrote:
> > On Sa, 2014-12-06 at 12:17 +0800, Jike Song wrote:
> > > I don't know that is exactly needed, we also need to have Windows
> > > driver considered.  However, I'm quite confident that, if things gonna
> > > work for IGD passthrough, it gonna work for GVT-g.
> >
> > I'd suggest to focus on q35 emulation.  q35 is new enough that a version
> > with integrated graphics exists, so the gap we have to close is *much*
> > smaller.
> >
> > In case guests expect a northbridge matching the chipset generation of
> > the graphics device (which I'd expect is the case, after digging a bit
> > in the igd and agpgart linux driver code) I think we should add proper
> > device emulation for them, i.e. comply q35-pcihost with
> > sandybridge-pcihost + ivybridge-pcihost + haswell-pcihost instead of
> > just copying over the pci ids from the host.  Most likely all those
> > variants can share most of the emulation code.
> 
> I don't think i915.ko should care about either northbridge nor pch on
> para-virtualized platforms. We do noodle around in there for the oddball
> memory controller setting and for some display stuff. But neither of that
> really applies to paravirtualized hw. And if there's any case like that we
> should  patch it out (like we do with some of the runtime pm code
> already).

Agree. Now Allen is working on how to avoid those tricky platform
stickiness in Windows gfx driver. We should do same thing in Linux
part too.

Thanks
Kevin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
