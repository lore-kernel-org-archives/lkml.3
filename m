Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3EAXQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:16:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33925 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab3EAXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:16:42 -0400
Date: Wed, 1 May 2013 16:16:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <20130501230254.GC15623@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305011606461.8804@chino.kir.corp.google.com>
References: <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org> <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com> <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com> <20130501211011.GD4466@pd.tnic>
 <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com> <20130501215604.GA15623@pd.tnic> <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com> <20130501222850.GB15623@pd.tnic> <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
 <20130501230254.GC15623@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Borislav Petkov wrote:

> > It means your patch is incomplete.
> 
> I'll gladly test and ack a patch which makes it complete.
> 
> Simple exercises in rhetoric about what does and what doesn't make sense
> means a rat's ass to me. You need to show me a *real* use case which you
> *actually* hit and this patch breaks it.
> 

What makes sense = a build that works.

You reported the breakage yourself:

arch/x86/built-in.o:(.data+0x2a0): undefined reference to `native_setup_msi_irqs'
arch/x86/built-in.o:(.data+0x2a8): undefined reference to `native_teardown_msi_irq'

That's because of this:

warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)

So you're missing CONFIG_X86_LOCAL_APIC and/or CONFIG_X86_IO_APIC, as 
already stated.  Those are strict requirements for your 
CONFIG_KVM_GUEST_COMMON_OPTIONS to build.  I suggest depending on them, 
most configs already have them.

You'll probably also want to depend on NET_CORE since it requires that as 
well.

That would probably make your patch complete.  Ingo does a lot of 
randconfig testing himself, so he'll probably run into these same issues, 
I don't think the "aww, shucks, that config doesn't make sense, we can 
allow the build to break" excuse will work too well.
