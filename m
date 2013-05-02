Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3EBAHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:07:07 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:36337 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3EBAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:07:03 -0400
Date: Wed, 1 May 2013 17:07:00 -0700 (PDT)
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
In-Reply-To: <20130501233530.GG15623@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305011705001.25497@chino.kir.corp.google.com>
References: <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com> <20130501211011.GD4466@pd.tnic> <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com> <20130501215604.GA15623@pd.tnic>
 <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com> <20130501222850.GB15623@pd.tnic> <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com> <20130501230254.GC15623@pd.tnic> <alpine.DEB.2.02.1305011606461.8804@chino.kir.corp.google.com>
 <20130501233530.GG15623@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Borislav Petkov wrote:

> See, we could've saved ourselves all the bullshit if you had started
> with the above.
> 

I had thought 

warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)

was obvious.

> I'll add those to the lineup:
> 
> select PCI
> select NET_CORE
> select X86_IO_APIC
> select X86_LOCAL_APIC
> 

No, you want to depend on X86_IO_APIC and X86_LOCAL_APIC, otherwise you'll 
just face the same issue one level deeper.
