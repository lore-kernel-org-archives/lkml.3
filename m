Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbaGWQCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:02:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:46086 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaGWQCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="547831250"
Message-ID: <53CFDC79.8040804@intel.com>
Date: Wed, 23 Jul 2014 09:02:01 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com> <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com> <53CE8EEC.2090402@intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE0170079E@shsmsx102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE0170079E@shsmsx102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 07:35 PM, Ren, Qiaowei wrote:
> The checking about MPX feature should be as follow:
> 
>         if (pcntxt_mask & XSTATE_EAGER) {
>                 if (eagerfpu == DISABLE) {
>                         pr_err("eagerfpu not present, disabling some xstate features: 0x%llx\n",
>                                         pcntxt_mask & XSTATE_EAGER);
>                         pcntxt_mask &= ~XSTATE_EAGER;
>                 } else {
>                         eagerfpu = ENABLE;
>                 }
>         }
> 
> This patch was merged into kernel the ending of last year (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669 )

Should we be doing a clear_cpu_cap(X86_FEATURE_MPX) in here?

This isn't major, but I can't _ever_ imagine a user being able to track
down why MPX is not working from this message.  Should we spruce it up
somehow?

