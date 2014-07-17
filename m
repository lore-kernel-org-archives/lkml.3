Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaGQKnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:43:43 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64364 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaGQKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:43:40 -0400
Message-ID: <53C7A8C5.2090002@redhat.com>
Date: Thu, 17 Jul 2014 12:43:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: nVMX: Fix fail to get nested ack intr's vector
 during nested vmexit
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com> <1405573011-41330-2-git-send-email-wanpeng.li@linux.intel.com> <53C78E37.5090807@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D9E@SHSMSX104.ccr.corp.intel.com> <20140717100130.GA9118@kernel>
In-Reply-To: <20140717100130.GA9118@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 12:01, Wanpeng Li ha scritto:
> That is my original proposal solution of this bug. However, what I concern
> after more think is since kvm_lapic_find_highest_irr will not clear
> irr, if the intr will be injected by kvm_86_ops->hwapic_irr_update(vcpu,
> kvm_lapic_find_highest_irr(vcpu)) which called by vcpu_enter_guest() again?
>
> Any idea, Paolo?

The processor should do that when it does the virtual interrupt 
delivery.  It will do (29.2.2):

    Vector := RVI;
    VISR[Vector] := 1;
    SVI := Vector;
    VIRR[Vector] := 0;
    If VIRR not empty
       then RVI := highest index of bit set in VIRR
       else RVI := 0
    Fi;
    deliver interrupt with Vector through IDT;

Please post a patch, so we can reason on it better.

Paolo
