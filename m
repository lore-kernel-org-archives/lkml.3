Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3E0O07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:26:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64704 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3E0O04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:26:56 -0400
Message-ID: <51A36D28.7090202@ozlabs.ru>
Date: Tue, 28 May 2013 00:26:48 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: David Gibson <david@gibson.dropbear.id.au>,
        Scott Wood <scottwood@freescale.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1369105607-20957-4-git-send-email-aik@ozlabs.ru> <1369256817.1374.29@scott-Lenovo-G560> <20130525024524.GA6112@boomeroo.fritz.box> <51A33418.40909@redhat.com>
In-Reply-To: <51A33418.40909@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 08:23 PM, Paolo Bonzini wrote:
> Il 25/05/2013 04:45, David Gibson ha scritto:
>>>> +	case KVM_CREATE_SPAPR_TCE_IOMMU: {
>>>> +		struct kvm_create_spapr_tce_iommu create_tce_iommu;
>>>> +		struct kvm *kvm = filp->private_data;
>>>> +
>>>> +		r = -EFAULT;
>>>> +		if (copy_from_user(&create_tce_iommu, argp,
>>>> +				sizeof(create_tce_iommu)))
>>>> +			goto out;
>>>> +		r = kvm_vm_ioctl_create_spapr_tce_iommu(kvm,
>>>> &create_tce_iommu);
>>>> +		goto out;
>>>> +	}
> 
> Would it make sense to make this the only interface for creating TCEs?
> That is, pass both a window_size and an IOMMU group id (or e.g. -1 for
> no hardware IOMMU usage), and have a single ioctl for both cases?
> There's some duplicated code between kvm_vm_ioctl_create_spapr_tce and
> kvm_vm_ioctl_create_spapr_tce_iommu.

Just few bits. Is there really much sense in making one function from those
two? I tried, looked a bit messy.

> KVM_CREATE_SPAPR_TCE could stay for backwards-compatibility, or you
> could just use a new capability and drop the old ioctl.

The old capability+ioctl already exist for quite a while and few QEMU
versions supporting it were released so we do not want just drop it. So
then what is the benefit of having a new interface with support of both types?

>  I'm not sure
> whether you're already considering the ABI to be stable for kvmppc.

Is any bit of KVM using it? Cannot see from Documentation/ABI.


-- 
Alexey
