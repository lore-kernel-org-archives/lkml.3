Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaLENDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:03:41 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39471 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaLENDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:03:39 -0500
Message-ID: <5481AD24.3000703@redhat.com>
Date: Fri, 05 Dec 2014 14:03:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.comp.freedesktop.xorg.drivers.intel,gmane.comp.emulators.kvm.devel,gmane.linux.kernel
To: Gerd Hoffmann <kraxel@redhat.com>, Jike Song <jike.song@intel.com>
CC: kvm@vger.kernel.org, "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        linux-kernel@vger.kernel.org, "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org>
In-Reply-To: <1417769421.11297.37.camel@nilsson.home.kraxel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/12/2014 09:50, Gerd Hoffmann wrote:
> A few comments on the kernel stuff (brief look so far, also
> compile-tested only, intel gfx on my test machine is too old).
> 
>  * Noticed the kernel bits don't even compile when configured as
>    module.  Everything (vgt, i915, kvm) must be compiled into the
>    kernel.

I'll add that the patch is basically impossible to review with all the
XenGT bits still in.  For example, the x86 emulator seems to be
unnecessary for KVMGT, but I am not 100% sure.

I would like a clear understanding of why/how Andrew Barnes was able to
do i915 passthrough (GVT-d) without hacking the ISA bridge, and why this
does not apply to GVT-g.

Paolo

>  * Design approach still seems to be i915 on vgt not the other way
>    around.
> 
> Qemu/SeaBIOS bits:
> 
> I've seen the host bridge changes identity from i440fx to
> copy-pci-ids-from-host.  Guess the reason for this is that seabios uses
> this device to figure whenever it is running on i440fx or q35.  Correct?
> 
> What are the exact requirements for the device?  Must it match the host
> exactly, to not confuse the guest intel graphics driver?  Or would
> something more recent -- such as the q35 emulation qemu has -- be good
> enough to make things work (assuming we add support for the
> graphic-related pci config space registers there)?
> 
> The patch also adds a dummy isa bridge at 0x1f.  Simliar question here:
> What exactly is needed here?  Would things work if we simply use the q35
> lpc device here?
> 
> more to come after I've read the paper linked above ...
> 
> cheers,
>   Gerd
> 
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
