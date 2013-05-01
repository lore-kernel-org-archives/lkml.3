Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab3EAWhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:37:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58042 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3EAWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:37:30 -0400
Date: Wed, 1 May 2013 15:37:28 -0700 (PDT)
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
In-Reply-To: <20130501222850.GB15623@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org> <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com> <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic> <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com> <20130501215604.GA15623@pd.tnic> <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com> <20130501222850.GB15623@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Borislav Petkov wrote:

> Ok, so let's step back a bit here: I've added this option with the idea
> to have it as a shortcut so that you don't go search for every commodity
> option when you want to boot the kernel as a kvm guest. Currently I have
> it in all.config when doing randconfig builds here. While I'm doing the
> randbuilds, why not boot it in kvm too while at it.
> 

If that shortcut is enabling options that fail to build, it may not be 
considered so useful.

> So I'm pretty sure we won't be able to plug all holes. However, let's
> try to plug only those which hinder *real* usage instead of contrived
> stuff.
> 

It's contrived to not have CONFIG_NET_CORE enabled?

And why are you enabling CONFIG_PCI_MSI for systems that don't have 
ARCH_SUPPORTS_MSI?  You need CONFIG_X86_LOCAL_APIC and CONFIG_X86_IO_APIC.

So let's take a step back from your step back: you want to have a shortcut 
to build a guest.  Great, so you're enabling options that such a kernel 
needs.  The problem is that you're neglecting options that those options 
need.  It means your patch is incomplete.
