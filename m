Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab3E1RqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:46:08 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:52952
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964871Ab3E1RqE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:46:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
Date: Tue, 28 May 2013 12:45:38 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: David Gibson <david@gibson.dropbear.id.au>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <51A2C888.4050704@ozlabs.ru> (from aik@ozlabs.ru on Sun May 26
	21:44:24 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1369763138.18630.3@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 09:44:24 PM, Alexey Kardashevskiy wrote:
> On 05/25/2013 12:45 PM, David Gibson wrote:
> > On Wed, May 22, 2013 at 04:06:57PM -0500, Scott Wood wrote:
> >> On 05/20/2013 10:06:46 PM, Alexey Kardashevskiy wrote:
> >>> diff --git a/arch/powerpc/kvm/powerpc.c  
> b/arch/powerpc/kvm/powerpc.c
> >>> index 8465c2a..da6bf61 100644
> >>> --- a/arch/powerpc/kvm/powerpc.c
> >>> @@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >>> +++ b/arch/powerpc/kvm/powerpc.c
> >>> 		break;
> >>> #endif
> >>> 	case KVM_CAP_SPAPR_MULTITCE:
> >>> +	case KVM_CAP_SPAPR_TCE_IOMMU:
> >>> 		r = 1;
> >>> 		break;
> >>> 	default:
> >>
> >> Don't advertise SPAPR capabilities if it's not book3s -- and
> >> probably there's some additional limitation that would be
> >> appropriate.
> >
> > So, in the case of MULTITCE, that's not quite right.  PR KVM can
> > emulate a PAPR system on a BookE machine, and there's no reason not  
> to
> > allow TCE acceleration as well.  We can't make it dependent on PAPR
> > mode being selected, because that's enabled per-vcpu, whereas these
> > capabilities are queried on the VM before the vcpus are created.
> >
> > CAP_SPAPR_TCE_IOMMU should be dependent on the presence of suitable
> > host side hardware (i.e. a PAPR style IOMMU), though.
> 
> 
> The capability says that the ioctl is supported. If there is no IOMMU  
> group
> registered, than it will fail with a reasonable error and nobody gets  
> hurt.
> What is the problem?

You could say that about a lot of the capabilities that just advertise  
the existence of new ioctls. :-)

Sometimes it's nice to know in advance whether it's supported, before  
actually requesting that something happen.

> >>> @@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
> >>> #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct
> >>> kvm_device_attr)
> >>> #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct
> >>> kvm_device_attr)
> >>>
> >>> +/* ioctl for SPAPR TCE IOMMU */
> >>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct
> >>> kvm_create_spapr_tce_iommu)
> >>
> >> Shouldn't this go under the vm ioctl section?
> 
> 
> The KVM_CREATE_SPAPR_TCE_IOMMU ioctl (the version for emulated  
> devices) is
> in this section so I decided to keep them together. Wrong?

You decided to keep KVM_CREATE_SPAPR_TCE_IOMMU together with  
KVM_CREATE_SPAPR_TCE_IOMMU?

-Scott
