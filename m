Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaIKKja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaIKKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:39:29 -0400
Message-ID: <54117BD3.5000506@redhat.com>
Date: Thu, 11 Sep 2014 12:39:15 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: tangchen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <5411776B.3070302@cn.fujitsu.com>
In-Reply-To: <5411776B.3070302@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 12:20, tangchen ha scritto:
>>>
>>> +    vmcs_write64(APIC_ACCESS_ADDR, hpa);
>> This has to be guarded by "if (!is_guest_mode(vcpu))".
> 
> Since we cannot get vcpu through kvm, I'd like to move this check to
> vcpu_reload_apic_access_page() when
> kvm_x86_ops->set_apic_access_page_addr()
> is called.

Good idea!  Though passing the vcpu to vmx_set_apic_access_page_addr
would also work.

Paolo
