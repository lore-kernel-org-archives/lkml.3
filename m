Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaFXCxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:53:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:10338 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaFXCxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,535,1400050800"; 
   d="scan'208";a="449111299"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: RE: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
Thread-Topic: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
Thread-Index: AQHPitp0g7xixZVNTkiLN9tFeBCqMZt+nJAAgAD2LmA=
Date: Tue, 24 Jun 2014 02:53:12 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016AF2DB@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com>
 <53A884B2.5070702@mit.edu>
In-Reply-To: <53A884B2.5070702@mit.edu>
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

On 2014-06-24, Andy Lutomirski wrote:
>> +	/* Make bounds tables and bouds directory unlocked. */
>> +	if (vm_flags & VM_LOCKED)
>> +		vm_flags &= ~VM_LOCKED;
> 
> Why?  I would expect MCL_FUTURE to lock these.
> 
Andy, I was just a little confused about LOCKED & POPULATE earlier and I thought VM_LOCKED is not necessary for MPX specific bounds tables. Now, this checking should be removed, and there should be mm_populate() for VM_LOCKED case after mmap_region():

   if (!IS_ERR_VALUE(addr) && (vm_flags & VM_LOCKED))
       mm_populate(addr, len);

Thanks,
Qiaowei

