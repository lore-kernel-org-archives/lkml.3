Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaLFEUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:20:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:64824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaLFEU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,527,1413270000"; 
   d="scan'208";a="643333774"
Message-ID: <5482835F.5090707@intel.com>
Date: Sat, 06 Dec 2014 12:17:35 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org>
In-Reply-To: <1417769421.11297.37.camel@nilsson.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 04:50 PM, Gerd Hoffmann wrote:
> A few comments on the kernel stuff (brief look so far, also
> compile-tested only, intel gfx on my test machine is too old).
>
>   * Noticed the kernel bits don't even compile when configured as
>     module.  Everything (vgt, i915, kvm) must be compiled into the
>     kernel.

Yes, that's planned to be done along with separating hypervisor-related
code from vgt.

>   * Design approach still seems to be i915 on vgt not the other way
>     around.

So far yes.

>
> Qemu/SeaBIOS bits:
>
> I've seen the host bridge changes identity from i440fx to
> copy-pci-ids-from-host.  Guess the reason for this is that seabios uses
> this device to figure whenever it is running on i440fx or q35.  Correct?
>

I did some trick in seabios/qemu. The purpose is to make qemu:

	- provide IDs of an old host bridge to SeaBIOS
	- provide IDs of new host bridge(the physical ones) to guest OS

So I made seabios to tell qemu that POST is done before jumping to guest
OS context.

This may be the simplest method to make things work, but yes, q35 emulation
of qemu may have this unnecessary, see below.

> What are the exact requirements for the device?  Must it match the host
> exactly, to not confuse the guest intel graphics driver?  Or would
> something more recent -- such as the q35 emulation qemu has -- be good
> enough to make things work (assuming we add support for the
> graphic-related pci config space registers there)?
>

I don't know that is exactly needed, we also need to have Windows
driver considered.  However, I'm quite confident that, if things gonna
work for IGD passthrough, it gonna work for GVT-g.

> The patch also adds a dummy isa bridge at 0x1f.  Simliar question here:
> What exactly is needed here?  Would things work if we simply use the q35
> lpc device here?
>

Ditto.

> more to come after I've read the paper linked above ...

Thanks for review :)

>
> cheers,
>    Gerd
>

--
Thanks,
Jike
