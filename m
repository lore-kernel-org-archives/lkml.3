Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaCGWMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:12:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:54695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCGWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:12:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="scan'208";a="488190157"
Message-ID: <531A4426.30504@linux.intel.com>
Date: Fri, 07 Mar 2014 14:11:50 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost> <53195336.9080606@linux.intel.com> <20140307055035.GA5230@localhost> <531A164B.8040402@linux.intel.com> <20140307191050.GA10961@redhat.com> <531A33A2.5030706@linux.intel.com> <20140307213856.GF5255@pd.tnic> <20140307220655.GA580@redhat.com>
In-Reply-To: <20140307220655.GA580@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 02:06 PM, Dave Jones wrote:
> On Fri, Mar 07, 2014 at 10:38:56PM +0100, Borislav Petkov wrote:
> 
>  > * Another option would be if we change the f/m/s of "qemu64" so that
>  > the test doesn't fire.
>  > 
>  > What also makes me wonder is why is this thing even called qemu64?? AMD
>  > family 6 was 32-bit only CPUs so 64 is kinda wrong IMO. I mean, the
>  > kernel code is in "ifdef CONFIG_X86_32" block so "qemu64" is patently
>  > wrong naming.
> 
> Additionally, fam:6 model:6 stepping 3 never existed in the real world afaict.
> I used to keep x86info's stepping db pretty up to date, and that only has knowledge
> of stepping 1 & 2.[*]  Modelling qemu on something from the real world might be
> a better idea than inventing new special cases.
> 
>  > Oh, and the thing has CPUID_EXT2_LM which is also a WTH moment for me.
>  > Paolo, what's going on here?
> 
> Yeah, this is a mess, there should be no family < 0xf with LM set.
> 
> 	Dave

For AMD, at least.  Intel obviously have a bunch of chips with family ==
6 and LM.

Perhaps Fengguang should switch from "qemu64,+smep,+smap" to something
like "Haswell,+smep,+smap" instead for the time being at least?

	-hpa

