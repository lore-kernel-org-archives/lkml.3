Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbaGXAts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:49:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:19179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830AbaGXAtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:49:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,720,1400050800"; 
   d="scan'208";a="574511472"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
Thread-Topic: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
Thread-Index: AQHPpKaiWp0ck2giqEe4I+NwpoujZZutWZiAgAEPVnA=
Date: Thu, 24 Jul 2014 00:49:43 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE01703006@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
 <1405921124-4230-10-git-send-email-qiaowei.ren@intel.com>
 <53CFE4F9.3000701@intel.com>
In-Reply-To: <53CFE4F9.3000701@intel.com>
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



On 2014-07-24, Hansen, Dave wrote:
> On 07/20/2014 10:38 PM, Qiaowei Ren wrote:
>> Since the kernel allocated those tables on-demand without userspace
>> knowledge, it is also responsible for freeing them when the
>> associated mappings go away.
>> 
>> Here, the solution for this issue is to hook do_munmap() to check
>> whether one process is MPX enabled. If yes, those bounds tables
>> covered in the virtual address region which is being unmapped will
>> be freed
> also.
> 
> This is the part of the code that I'm the most concerned about.
> 
> Could you elaborate on how you've tested this to make sure it works OK?

I can check a lot of debug information when one VMA and related bounds tables are allocated and freed through adding a lot of print() like log into kernel/runtime. Do you think this is enough?

Thanks,
Qiaowei
