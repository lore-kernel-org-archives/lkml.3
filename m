Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab3DPSr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:47:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:34752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab3DPSr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:47:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,487,1363158000"; 
   d="scan'208";a="295827077"
Message-ID: <516D9CD5.6000807@linux.intel.com>
Date: Tue, 16 Apr 2013 11:47:49 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@linux.intel.com>
CC: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
References: <OF000BBE68.EBB4E92E-ON48257B4F.0010C2E7-48257B4F.0013FB89@zte.com.cn> <516D9A74.8030109@linux.intel.com>
In-Reply-To: <516D9A74.8030109@linux.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/16/2013 11:37 AM, Dave Hansen wrote:
> Instead of bothering to store the index, why not just calculate it, like:
> 
> On 04/15/2013 08:37 PM, zhang.yi20@zte.com.cn wrote:
>> +static inline int get_page_compound_index(struct page *page)
>> +{
>> +       if (PageHead(page))
>> +               return 0;
>> +       return compound_head(page) - page;
>> +}
> 
> BTW, you've really got to get your mail client fixed.  Your patch is
> still line-wrapped.

And with this it would no longer be necessary to store this index at
all, eliminating all changes to the MM other than this accessor function
- which if not needed there could be added to futex.c, or even replaced with
"page_head - page" in get_futex_key() right?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
