Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaFWUDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:03:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:60923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbaFWUDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:03:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,532,1400050800"; 
   d="scan'208";a="562067770"
Message-ID: <53A88806.1060908@intel.com>
Date: Mon, 23 Jun 2014 13:03:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Qiaowei Ren <qiaowei.ren@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu>
In-Reply-To: <53A884B2.5070702@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 12:49 PM, Andy Lutomirski wrote:
> On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
>> This patch adds one MPX specific mmap interface, which only handles
>> mpx related maps, including bounds table and bounds directory.
>>
>> In order to track MPX specific memory usage, this interface is added
>> to stick new vm_flag VM_MPX in the vma_area_struct when create a
>> bounds table or bounds directory.
> 
> I imagine the linux-mm people would want to think about any new vm flag.
>  Why is this needed?

These tables can take huge amounts of memory.  In the worst-case
scenario, the tables can be 4x the size of the data structure being
tracked.  IOW, a 1-page structure can require 4 bounds-table pages.

My expectation is that folks using MPX are going to be keen on figuring
out how much memory is being dedicated to it.  With this feature, plus
some grepping in /proc/$pid/smaps one could take a pretty good stab at it.

I know VM flags are scarce, and I'm open to other ways to skin this cat.

