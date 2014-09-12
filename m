Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaILE7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:59:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:29336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaILE7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,510,1406617200"; 
   d="scan'208";a="572123636"
Message-ID: <54127DC3.40107@intel.com>
Date: Thu, 11 Sep 2014 21:59:47 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 09/10] x86, mpx: cleanup unused bound tables
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-10-git-send-email-qiaowei.ren@intel.com> <5411B8C3.7080205@intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE017A4015@shsmsx102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE017A4015@shsmsx102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:02 PM, Ren, Qiaowei wrote:
> On 2014-09-11, Hansen, Dave wrote:
>> On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
>>> + * This function will be called by do_munmap(), and the VMAs
>>> + covering
>>> + * the virtual address region start...end have already been split
>>> + if
>>> + * necessary and remvoed from the VMA list.
>>
>> "remvoed" -> "removed"
>>
>>> +void mpx_unmap(struct mm_struct *mm,
>>> +		unsigned long start, unsigned long end) {
>>> +	int ret;
>>> +
>>> +	ret = mpx_try_unmap(mm, start, end);
>>> +	if (ret == -EINVAL)
>>> +		force_sig(SIGSEGV, current);
>>> +}
>> 
>> In the case of a fault during an unmap, this just ignores the 
>> situation and returns silently.  Where is the code to retry the 
>> freeing operation outside of mmap_sem?
> 
> Dave, you mean delayed_work code? According to our discussion, it
> will be deferred to another mainline post.

OK, fine.  Just please call that out in the description.

