Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaGDHmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaGDHmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:42:19 -0400
Message-ID: <53B65AC8.1010901@redhat.com>
Date: Fri, 04 Jul 2014 09:42:00 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>, Bandan Das <bsd@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140703065955.GA4236@kernel> <jpgk37u8iae.fsf@redhat.com> <20140704025250.GA2849@kernel> <53B63EF2.6000800@siemens.com>
In-Reply-To: <53B63EF2.6000800@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2014 07:43, Jan Kiszka ha scritto:
> Which version (hash) of kvm-unit-tests are you using? All tests up to
> 307621765a are running fine here, but since a0e30e712d not much is
> completing successfully anymore:

Which test failed to init and triggered the change in the patch?

The patch was needed here to fix failures when KVM is loaded with ept=0.

BTW, "FAIL: intercepted interrupt + hlt" is always failing here too 
(Xeon E5 Sandy Bridge).

Paolo

> enabling apic
> paging enabled
> cr0 = 80010011
> cr3 = 7fff000
> cr4 = 20
> PASS: test vmxon with FEATURE_CONTROL cleared
> PASS: test vmxon without FEATURE_CONTROL lock
> PASS: test enable VMX in FEATURE_CONTROL
> PASS: test FEATURE_CONTROL lock bit
> PASS: test vmxon
> FAIL: test vmptrld
> PASS: test vmclear
> init_vmcs : make_vmcs_current error
> FAIL: test vmptrst
> init_vmcs : make_vmcs_current error
> vmx_run : vmlaunch failed.
> FAIL: test vmlaunch
> FAIL: test vmlaunch
>
> SUMMARY: 10 tests, 4 unexpected failures
>

