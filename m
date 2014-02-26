Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaBZS7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:59:46 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:61118 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaBZS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:59:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140226185513.GL22728@two.firstfloor.org>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net> <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com> <20140226185513.GL22728@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Feb 2014 10:59:17 -0800
Message-ID: <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:55 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> I'm suggesting a perf event option, just like the way that PEBS works.
>
> Right now it's a somewhat experimental feature and just having
> the sysctl is fine. If it turns out that is what everyone uses
> such an option could be still added later.

I'm a bit worried that the syscall will be stuck as ABI forever,
though.  Its presence will make adding a different configuration
mechanism awkward.

>
> I suspect most people would still use FP if they can, just use
> the LBRs if that doesn't work.

I wonder if anyone who uses perf for userspace profiling *ever* uses
FP and gets away with it.  There's precious little userspace software
compiled with frame pointers these days on most architectures.

I have a concrete reason for this question: it would be nice to
compile the vDSO with frame pointers off.  IIRC there would be a
significant performance gain, and I think the only thing that would
break is perf.  But it looks like perf will have nice elfutils unwind
support in 3.15, and if FP support is useless anyway...

--Andy
