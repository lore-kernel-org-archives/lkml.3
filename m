Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaHVIgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbaHVIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:36:19 -0400
Message-ID: <53F700F7.8020909@redhat.com>
Date: Fri, 22 Aug 2014 10:36:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1408621610-9665-1-git-send-email-wanpeng.li@linux.intel.com> <1408621610-9665-2-git-send-email-wanpeng.li@linux.intel.com> <53F5E720.9000308@redhat.com> <20140821233029.GA2420@kernel>
In-Reply-To: <20140821233029.GA2420@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/08/2014 01:30, Wanpeng Li ha scritto:
> Maybe I misunderstand your comments "On real hardware you could point
> the virtual-APIC page to an invalid address."
> http://lists.openwall.net/linux-kernel/2014/08/07/344
> 

That referred to an address that doesn't correspond to RAM.  You can use
addresses like these in a real processor.

But the manual says that "if the “use TPR shadow” VM-execution control
is 1, VM entry ensures that the virtual-APIC address is 4-KByte aligned"
(24.6.8 Controls For APIC Virtualization).  This is the check that is
missing.

Paolo
