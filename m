Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaILDCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:02:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:61395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaILDCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385068084"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 09/10] x86, mpx: cleanup unused bound tables
Thread-Topic: [PATCH v8 09/10] x86, mpx: cleanup unused bound tables
Thread-Index: AQHPzZ4ZD4a5PLioWE2GYqpHSFSgo5v7gI+AgAFOsHA=
Date: Fri, 12 Sep 2014 03:02:38 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017A4015@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-10-git-send-email-qiaowei.ren@intel.com>
 <5411B8C3.7080205@intel.com>
In-Reply-To: <5411B8C3.7080205@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014-09-11, Hansen, Dave wrote:
> On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
>> + * This function will be called by do_munmap(), and the VMAs
>> + covering
>> + * the virtual address region start...end have already been split
>> + if
>> + * necessary and remvoed from the VMA list.
> 
> "remvoed" -> "removed"
> 
>> +void mpx_unmap(struct mm_struct *mm,
>> +		unsigned long start, unsigned long end) {
>> +	int ret;
>> +
>> +	ret = mpx_try_unmap(mm, start, end);
>> +	if (ret == -EINVAL)
>> +		force_sig(SIGSEGV, current);
>> +}
> 
> In the case of a fault during an unmap, this just ignores the
> situation and returns silently.  Where is the code to retry the
> freeing operation outside of mmap_sem?

Dave, you mean delayed_work code? According to our discussion, it will be deferred to another mainline post.

Thanks,
Qiaowei

