Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaLJQ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:59:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbaLJQ7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:59:15 -0500
Message-ID: <54887BD9.7030903@redhat.com>
Date: Wed, 10 Dec 2014 17:59:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Tian, Kevin" <kevin.tian@intel.com>, Gerd Hoffmann <kraxel@redhat.com>,
        "Song, Jike" <jike.song@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org> <5481AD24.3000703@redhat.com> <AADFC41AFE54684AB9EE6CBC0274A5D12611365D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D12611365D@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/12/2014 03:49, Tian, Kevin wrote:
> - Now we have XenGT/KVMGT separately maintained, and KVMGT lags
> behind XenGT regarding to features and qualities. Likely you'll continue
> see stale code (like Xen inst decoder) for some time. In the future we
> plan to maintain a single kernel repo for both, so KVMGT can share
> same quality as XenGT once KVM in-kernel dm framework is stable.
> 
> - Regarding to Qemu hacks, KVMGT really doesn't have any different 
> requirements as what have been discussed for GPU pass-through, e.g. 
> about ISA bridge. Our implementation is based on an old Qemu repo, 
> and honestly speaking not cleanly developed, because we know we
> can leverage from GPU pass-through support once it's in Qemu. At 
> that time we'll leverage the same logic with minimal changes to 
> hook KVMGT mgmt. APIs (e.g. create/destroy a vGPU instance). So
> we can ignore this area for now. :-)

Could the virtual device model introduce new registers in order to avoid
poking at the ISA bridge?  I'm not sure that you "can leverage from GPU
pass-through support once it's in Qemu", since the Xen IGD passthrough
support is being added to a separate machine that is specific to Xen IGD
passthrough; no ISA bridge hacking will probably be allowed on the "-M
pc" and "-M q35" machine types.

Paolo
