Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaCGVBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:01:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:12389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbaCGVBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:01:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="scan'208";a="496063555"
Message-ID: <531A33A2.5030706@linux.intel.com>
Date: Fri, 07 Mar 2014 13:01:22 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost> <53195336.9080606@linux.intel.com> <20140307055035.GA5230@localhost> <531A164B.8040402@linux.intel.com> <20140307191050.GA10961@redhat.com>
In-Reply-To: <20140307191050.GA10961@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 11:10 AM, Dave Jones wrote:
> On Fri, Mar 07, 2014 at 10:56:11AM -0800, H. Peter Anvin wrote:
>  > On 03/06/2014 09:50 PM, Fengguang Wu wrote:
>  > >>
>  > >> Unfortunately these things are hard to fix in Qemu.
>  > > 
>  > > OK. As an alternative, is it possible to pass one of the below CPUID flags in
>  > > the Qemu command line, so as to quiet the warning?
>  > > 
>  > 
>  > I don't see the AMD SMP CPUID flag in there.
>  > 
>  > Boris, could you help?  The problem is that "qemu -cpu
>  > qemu64,+smep,+smap" identifies as an AMD CPU which triggers a
>  > warning/taint because the SMP flag isn't set.
> 
> qemu64 triggers this ? That spew comes from amd_k7_smp_check() 
> which should only run on family 6, which was all 32bit.
> 

[    0.152749] smpboot: CPU0: AMD QEMU Virtual CPU version 1.6.0 (fam:
06, model: 02, stepping: 03)

Seems they are using a really odd CPUID combination, then.

	-hpa

