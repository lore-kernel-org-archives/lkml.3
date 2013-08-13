Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3HMQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:44:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab3HMQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:44:28 -0400
Message-ID: <520A620B.6070702@zytor.com>
Date: Tue, 13 Aug 2013 09:42:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, jeremy@goop.org, konrad.wilk@oracle.com,
        gleb@redhat.com, pbonzini@redhat.com, gregkh@suse.de,
        peterz@infradead.org, tglx@linutronix.de, agraf@suse.de,
        riel@redhat.com, avi.kivity@gmail.com, habanero@linux.vnet.ibm.com,
        chegu_vinod@hp.com, ouyang@cs.pitt.edu, drjones@redhat.com,
        attilio.rao@citrix.com, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org, kvm@vger.kernel.org,
        andi@firstfloor.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        stefano.stabellini@eu.citrix.com, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [PATCH RESEND V13 14/14] kvm : Paravirtual ticketlocks support
 for linux guests running on KVM hypervisor
References: <y> <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1376058122-8248-15-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130810193849.GA25260@linux.vnet.ibm.com>
In-Reply-To: <20130810193849.GA25260@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raghavendra...

Even with this latest patch this branch is broken:

:(.discard+0x6108): multiple definition of `__pcpu_unique_lock_waiting'
arch/x86/xen/built-in.o:(.discard+0x23): first defined here
  CC      drivers/firmware/google/gsmi.o
arch/x86/kernel/built-in.o:(.discard+0x6108): multiple definition of
`__pcpu_unique_lock_waiting'
arch/x86/xen/built-in.o:(.discard+0x23): first defined here
  CC      sound/core/seq/oss/seq_oss_init.o

This is trivially reproducible by doing a build with "make allyesconfig".

Please fix and *verify* it is fixed before resubmitting.

I will be away so Ingo will have to handle the resubmission.

	-hpa

