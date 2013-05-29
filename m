Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3E2AUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:20:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45787 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3E2AUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:20:48 -0400
Message-ID: <51A549D9.3080605@ozlabs.ru>
Date: Wed, 29 May 2013 10:20:41 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1369758773.18630.1@snotra>
In-Reply-To: <1369758773.18630.1@snotra>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 02:32 AM, Scott Wood wrote:
> On 05/24/2013 09:45:24 PM, David Gibson wrote:
>> On Wed, May 22, 2013 at 04:06:57PM -0500, Scott Wood wrote:
>> > On 05/20/2013 10:06:46 PM, Alexey Kardashevskiy wrote:
>> > >diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>> > >index 8465c2a..da6bf61 100644
>> > >--- a/arch/powerpc/kvm/powerpc.c
>> > >@@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>> > >+++ b/arch/powerpc/kvm/powerpc.c
>> > >         break;
>> > > #endif
>> > >     case KVM_CAP_SPAPR_MULTITCE:
>> > >+    case KVM_CAP_SPAPR_TCE_IOMMU:
>> > >         r = 1;
>> > >         break;
>> > >     default:
>> >
>> > Don't advertise SPAPR capabilities if it's not book3s -- and
>> > probably there's some additional limitation that would be
>> > appropriate.
>>
>> So, in the case of MULTITCE, that's not quite right.  PR KVM can
>> emulate a PAPR system on a BookE machine, and there's no reason not to
>> allow TCE acceleration as well.
> 
> That might (or might not; consider things like Altivec versus SPE opcode
> conflict, whether unimplemented SPRs trap, behavior of unprivileged
> SPRs/instructions, etc) be true in theory, but it's not currently a
> supported configuration.  BookE KVM does not support emulating a different
> CPU than the host.  In the unlikely case that ever changes to the point of
> allowing PAPR guests on a BookE host, then we can revisit how to properly
> determine whether the capability is supported, but for now the capability
> will never be valid in the CONFIG_BOOKE case (though I'd rather see it
> depend on an appropriate book3s symbol than depend on !BOOKE).
> 
> Or we could just leave it as is, and let it indicate whether the host
> kernel supports the feature in general, with the user needing to understand
> when it's applicable...  I'm a bit confused by the documentation, however
> -- the MULTITCE capability was documented in the "capabilities that can be
> enabled" section, but I don't see where it can be enabled.


True, it cannot be enabled (but it could be enabled a long time ago), it is
either supported or not, I'll fix the documentation. Thanks!


-- 
Alexey
