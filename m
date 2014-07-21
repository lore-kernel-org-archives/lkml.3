Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaGUGLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:11:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:55634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaGUGLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="546451639"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Topic: [PATCH v7 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Index: AQHPpKofR5GdO0yH5UWuHRo/1L3w7ZuqC0Cg
Date: Mon, 21 Jul 2014 06:11:19 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016FC1D7@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
	<1405921124-4230-8-git-send-email-qiaowei.ren@intel.com>
 <87ppgz2qio.fsf@tassilo.jf.intel.com>
In-Reply-To: <87ppgz2qio.fsf@tassilo.jf.intel.com>
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



On 2014-07-21, Andi Kleen wrote:
> Qiaowei Ren <qiaowei.ren@intel.com> writes:
>> +	 */
>> +#ifdef CONFIG_X86_64
>> +	insn->x86_64 = 1;
>> +	insn->addr_bytes = 8;
>> +#else
>> +	insn->x86_64 = 0;
>> +	insn->addr_bytes = 4;
>> +#endif
> 
> How would that handle compat mode on a 64bit kernel?
> Should likely look at the code segment instead of ifdef.
>> +	/* Note: the upper 32 bits are ignored in 32-bit mode. */
> 
> Again correct for compat mode? I believe the upper bits are undefined.
> 
Compat mode will be supported on next patch in future, as 0/ patch mentioned. ^-^

Thanks,
Qiaowei
