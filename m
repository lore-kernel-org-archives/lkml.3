Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaKRPnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:43:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38682 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbaKRPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:43:12 -0500
Date: Tue, 18 Nov 2014 16:43:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
Message-ID: <20141118154308.GB5238@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
 <1416251225-17721-14-git-send-email-eranian@google.com>
 <20141117230232.GC25157@pd.tnic>
 <alpine.DEB.2.11.1411180025270.3909@nanos>
 <20141117235841.GD25157@pd.tnic>
 <alpine.DEB.2.11.1411180115420.3909@nanos>
 <CABPqkBQp36s=cKgy0e9hpARgY=z1AucXyToBVtykOvyuAr8AyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBQp36s=cKgy0e9hpARgY=z1AucXyToBVtykOvyuAr8AyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:29:59PM +0100, Stephane Eranian wrote:
> I am trying to get a better understanding of this scheme.
> 
> status:
>   - a summary of what is enabled/disabled?
>   - With description (as suggested by Boris)?
>   - File is readonly
>   - is that printing a variable length bitmask?

Should be the easiest. Maybe extend/add to the X86_BUG() functionality
in arch/x86/include/asm/cpufeature.h which already deals with CPU bugs.

> enable_workaround:
>    - provide the bit number (of the workaround) to enable the workaround

Right, writing the bit number could be part of the description message
above - just so that users know how to control the interface.

>    - File is write-only
> 
> disable_workaround:
>    - provide the bit number (of the workaround) to disable the workaround
>    - File is write-only
> 
> The split enable/disable is to avoid the read-modify-write issue.
> 
> Am I getting this right?
> 
> I understand the value of this proposition. But, I feel,  it is beyond the scope
> of the patch series to workaround the PMU bug. Initially, we had
> talked about not
> even providing the sysfs file. Now, the series adjusts the workaround
> on boot. The series is restructured so that the sysfs patch is the last
> one and is totally optional. I think we should implement the proposed scheme
> but we should not delay the review and merge of the rest of the patch series
> for this. But I can propose a separate patch series to implement the proposed
> scheme.

Right, IMHO, we can always add sysfs structure later, when its design is
sane. What we should absolutely avoid is exposing something to userspace
now and then try to hide it/replace it with something else and break
userspace, which, as we all know, is a no-no, punishable by Linus coming
to your house with a bat.

:-) :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
