Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaAMDOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:14:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:30927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaAMDOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:14:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,650,1384329600"; 
   d="scan'208";a="464077914"
Message-ID: <52D358EA.8090800@intel.com>
Date: Mon, 13 Jan 2014 11:09:30 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com> <20140112093013.GB3664@pd.tnic> <52D2C791.2030802@zytor.com> <20140112170354.GC3655@pd.tnic>
In-Reply-To: <20140112170354.GC3655@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 01:03 AM, Borislav Petkov wrote:
> On Sun, Jan 12, 2014 at 08:49:21AM -0800, H. Peter Anvin wrote:
>> I saw a previous version of the code that did that, and it really
>> didn't work out well -- it ended up being more complex and slower.
>
> I suspected as much.
>
> But, we still probably should use the generic struct insn, insn_field,
> etc and act on them in mpx.c instead of defining our own mpx_insn,
> mpx_insn_field, X86_MODRM_MOD, etc in the header which are more or less
> copied from insn.h, right?
>

I tried to use generic structure and macro, but many members of generic 
struct insn are not used for MPX, and except this I have to add one 
member into this structure. So I define mpx specific struct insn.

And so I guess only struct insn_field and several macros like X86_XXX 
may use generic version. Anyway, I will try to use their generic version 
in next version for this patchset.

Thanks,
Qiaowei
