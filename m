Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbaLKAeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:34:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:46503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbaLKAeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496964083"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        "Song, Jike" <jike.song@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: RE: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
Thread-Topic: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of
 Intel GVT-g(full GPU virtualization) for KVM
Thread-Index: AQHQEGiLR9sn/FTTFEy+ONRxxlNBGJyAcNAAgAYSpgCAAgrSgIABA5pw
Date: Thu, 11 Dec 2014 00:33:51 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D126116679@SHSMSX101.ccr.corp.intel.com>
References: <547FC5DE.4010701@intel.com>
 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
 <5481AD24.3000703@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D12611365D@SHSMSX101.ccr.corp.intel.com>
 <54887BD9.7030903@redhat.com>
In-Reply-To: <54887BD9.7030903@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBB0YITZ009821

> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Thursday, December 11, 2014 12:59 AM
> 
> On 09/12/2014 03:49, Tian, Kevin wrote:
> > - Now we have XenGT/KVMGT separately maintained, and KVMGT lags
> > behind XenGT regarding to features and qualities. Likely you'll continue
> > see stale code (like Xen inst decoder) for some time. In the future we
> > plan to maintain a single kernel repo for both, so KVMGT can share
> > same quality as XenGT once KVM in-kernel dm framework is stable.
> >
> > - Regarding to Qemu hacks, KVMGT really doesn't have any different
> > requirements as what have been discussed for GPU pass-through, e.g.
> > about ISA bridge. Our implementation is based on an old Qemu repo,
> > and honestly speaking not cleanly developed, because we know we
> > can leverage from GPU pass-through support once it's in Qemu. At
> > that time we'll leverage the same logic with minimal changes to
> > hook KVMGT mgmt. APIs (e.g. create/destroy a vGPU instance). So
> > we can ignore this area for now. :-)
> 
> Could the virtual device model introduce new registers in order to avoid
> poking at the ISA bridge?  I'm not sure that you "can leverage from GPU
> pass-through support once it's in Qemu", since the Xen IGD passthrough
> support is being added to a separate machine that is specific to Xen IGD
> passthrough; no ISA bridge hacking will probably be allowed on the "-M
> pc" and "-M q35" machine types.
> 

My point is that KVMGT doesn't introduce new requirements as what's
required in IGD passthrough case, because all the hacks you see now
is to satisfy guest graphics driver's expectation. I haven't follow up the
KVM IGD passthrough progress, but if it doesn't require ISA bridge hacking
the same trick can be adopted by KVMGT too. You may know Allen is
working on driver changes to avoid causing those hacks in Qemu side.
That effort will benefit us too. So I don't think this is a KVMGT specific
issue, and we need a common solution to close this gap instead of 
hacking vGPU device model alone.

Thanks
Kevin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
