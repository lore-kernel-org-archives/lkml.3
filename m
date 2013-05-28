Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813Ab3E1QdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:33:09 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:19201 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934675Ab3E1QdG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:33:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
Date: Tue, 28 May 2013 11:32:53 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
To: David Gibson <david@gibson.dropbear.id.au>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20130525024524.GA6112@boomeroo.fritz.box> (from
	david@gibson.dropbear.id.au on Fri May 24 21:45:24 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1369758773.18630.1@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 09:45:24 PM, David Gibson wrote:
> On Wed, May 22, 2013 at 04:06:57PM -0500, Scott Wood wrote:
> > On 05/20/2013 10:06:46 PM, Alexey Kardashevskiy wrote:
> > >diff --git a/arch/powerpc/kvm/powerpc.c  
> b/arch/powerpc/kvm/powerpc.c
> > >index 8465c2a..da6bf61 100644
> > >--- a/arch/powerpc/kvm/powerpc.c
> > >@@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> > >+++ b/arch/powerpc/kvm/powerpc.c
> > > 		break;
> > > #endif
> > > 	case KVM_CAP_SPAPR_MULTITCE:
> > >+	case KVM_CAP_SPAPR_TCE_IOMMU:
> > > 		r = 1;
> > > 		break;
> > > 	default:
> >
> > Don't advertise SPAPR capabilities if it's not book3s -- and
> > probably there's some additional limitation that would be
> > appropriate.
> 
> So, in the case of MULTITCE, that's not quite right.  PR KVM can
> emulate a PAPR system on a BookE machine, and there's no reason not to
> allow TCE acceleration as well.

That might (or might not; consider things like Altivec versus SPE  
opcode conflict, whether unimplemented SPRs trap, behavior of  
unprivileged SPRs/instructions, etc) be true in theory, but it's not  
currently a supported configuration.  BookE KVM does not support  
emulating a different CPU than the host.  In the unlikely case that  
ever changes to the point of allowing PAPR guests on a BookE host, then  
we can revisit how to properly determine whether the capability is  
supported, but for now the capability will never be valid in the  
CONFIG_BOOKE case (though I'd rather see it depend on an appropriate  
book3s symbol than depend on !BOOKE).

Or we could just leave it as is, and let it indicate whether the host  
kernel supports the feature in general, with the user needing to  
understand when it's applicable...  I'm a bit confused by the  
documentation, however -- the MULTITCE capability was documented in the  
"capabilities that can be enabled" section, but I don't see where it  
can be enabled.

-Scott
