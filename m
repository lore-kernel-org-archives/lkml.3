Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935635Ab3DRAJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:09:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42139 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285Ab3DRAJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:09:22 -0400
Date: Wed, 17 Apr 2013 17:09:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>, Yang Zhang <yang.z.zhang@Intel.com>
cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: [patch] x86, kvm: fix build failure with CONFIG_SMP disabled
In-Reply-To: <516F37FF.8040703@infradead.org>
Message-ID: <alpine.DEB.2.02.1304171707090.24494@chino.kir.corp.google.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au> <516EE5AB.4080201@infradead.org> <alpine.DEB.2.02.1304171555030.10112@chino.kir.corp.google.com> <alpine.DEB.2.02.1304171609580.5541@chino.kir.corp.google.com>
 <516F37FF.8040703@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Randy Dunlap wrote:

> On 04/17/13 16:12, David Rientjes wrote:
> > The build fails when CONFIG_SMP is disabled:
> > 
> > 	arch/x86/kvm/vmx.c: In function 'vmx_deliver_posted_interrupt':
> > 	arch/x86/kvm/vmx.c:3950:3: error: 'apic' undeclared (first use in this function)
> > 
> > Fix it by including the necessary header.
> 
> Sorry, i386 build still fails with the same error message plus this one:
> 
> ERROR: "apic" [arch/x86/kvm/kvm-intel.ko] undefined!
> 

Ahh, that's because you don't have CONFIG_X86_LOCAL_APIC as you already 
mentioned.  So it looks like this error can manifest in two different ways 
and we got different reports.

This failure came from "KVM: VMX: Add the deliver posted interrupt 
algorithm", so adding Yang to the cc to specify the dependency this has on 
apic and how it can be protected without CONFIG_X86_LOCAL_APIC on i386.
