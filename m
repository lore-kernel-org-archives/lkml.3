Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3HMQ4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:56:00 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62242 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3HMQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:55:58 -0400
Date: Tue, 13 Aug 2013 18:55:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        konrad.wilk@oracle.com, gleb@redhat.com, pbonzini@redhat.com,
        gregkh@suse.de, peterz@infradead.org, tglx@linutronix.de,
        agraf@suse.de, riel@redhat.com, avi.kivity@gmail.com,
        habanero@linux.vnet.ibm.com, chegu_vinod@hp.com, ouyang@cs.pitt.edu,
        drjones@redhat.com, attilio.rao@citrix.com, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org, kvm@vger.kernel.org,
        andi@firstfloor.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        stefano.stabellini@eu.citrix.com, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [PATCH RESEND V13 14/14] kvm : Paravirtual ticketlocks support
 for linux guests running on KVM hypervisor
Message-ID: <20130813165552.GA6795@gmail.com>
References: <y>
 <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <1376058122-8248-15-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20130810193849.GA25260@linux.vnet.ibm.com>
 <520A620B.6070702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A620B.6070702@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Raghavendra...
> 
> Even with this latest patch this branch is broken:
> 
> :(.discard+0x6108): multiple definition of `__pcpu_unique_lock_waiting'
> arch/x86/xen/built-in.o:(.discard+0x23): first defined here
>   CC      drivers/firmware/google/gsmi.o
> arch/x86/kernel/built-in.o:(.discard+0x6108): multiple definition of
> `__pcpu_unique_lock_waiting'
> arch/x86/xen/built-in.o:(.discard+0x23): first defined here
>   CC      sound/core/seq/oss/seq_oss_init.o
> 
> This is trivially reproducible by doing a build with "make allyesconfig".
> 
> Please fix and *verify* it is fixed before resubmitting.
> 
> I will be away so Ingo will have to handle the resubmission.

Would be nice to have a delta fix patch against tip:x86/spinlocks, which 
I'll then backmerge into that series via rebasing it.

Thanks,

	Ingo
