Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbaDIXK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:10:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:32380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbaDIXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,829,1389772800"; 
   d="scan'208";a="490329543"
Message-ID: <5345D360.5000506@linux.intel.com>
Date: Wed, 09 Apr 2014 16:10:24 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com> <53444220.50009@intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com> <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost>
In-Reply-To: <20140409230114.GB8370@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 04:01 PM, Fengguang Wu wrote:
> CC the KVM people: it looks like a KVM problem that can be triggered by
> 
>         qemu-system-x86_64 -cpu Haswell,+smep,+smap

I'm really confused.  First of all, is this a KVM problem or is it a
Qemu JIT problem?

Either seems really wonky.  It is questionable at best whether or not
Qemu in JIT mode should set the hypervisor bit IMO.  However, even so,
you *better* not call VMCALL *just* because the hypervisor bit is set.

The reason for it is that you have absolutely no idea what VMCALL is
going to do on any one hypervisor... different hypervisors even use
completely different conventions for VMCALL, and some might not accept
VMCALL at all and might just terminate your guest with extreme prejudice.

So what is actually going on here?

	-hpa

