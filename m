Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3E0KXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:23:33 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44743 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3E0KXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:23:31 -0400
Message-ID: <51A33418.40909@redhat.com>
Date: Mon, 27 May 2013 12:23:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Scott Wood <scottwood@freescale.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1369105607-20957-4-git-send-email-aik@ozlabs.ru> <1369256817.1374.29@scott-Lenovo-G560> <20130525024524.GA6112@boomeroo.fritz.box>
In-Reply-To: <20130525024524.GA6112@boomeroo.fritz.box>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/05/2013 04:45, David Gibson ha scritto:
>> >+	case KVM_CREATE_SPAPR_TCE_IOMMU: {
>> >+		struct kvm_create_spapr_tce_iommu create_tce_iommu;
>> >+		struct kvm *kvm = filp->private_data;
>> >+
>> >+		r = -EFAULT;
>> >+		if (copy_from_user(&create_tce_iommu, argp,
>> >+				sizeof(create_tce_iommu)))
>> >+			goto out;
>> >+		r = kvm_vm_ioctl_create_spapr_tce_iommu(kvm,
>> >&create_tce_iommu);
>> >+		goto out;
>> >+	}

Would it make sense to make this the only interface for creating TCEs?
That is, pass both a window_size and an IOMMU group id (or e.g. -1 for
no hardware IOMMU usage), and have a single ioctl for both cases?
There's some duplicated code between kvm_vm_ioctl_create_spapr_tce and
kvm_vm_ioctl_create_spapr_tce_iommu.

KVM_CREATE_SPAPR_TCE could stay for backwards-compatibility, or you
could just use a new capability and drop the old ioctl.  I'm not sure
whether you're already considering the ABI to be stable for kvmppc.

Paolo
