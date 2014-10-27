Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaJ0Bpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:45:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:49646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaJ0Bpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:45:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="625947589"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: RE: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Topic: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Index: AQHP5dg7yyhiQxbkmEGH5PJVxeeZs5w+vGAAgASFDTA=
Date: Mon, 27 Oct 2014 01:43:00 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE0180ED16@shsmsx102.ccr.corp.intel.com>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com>
 <1413088915-13428-10-git-send-email-qiaowei.ren@intel.com>
 <alpine.DEB.2.11.1410241408360.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410241408360.5308@nanos>
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



On 2014-10-24, Thomas Gleixner wrote:
> On Sun, 12 Oct 2014, Qiaowei Ren wrote:
> 
>> This patch sets bound violation fields of siginfo struct in #BR
>> exception handler by decoding the user instruction and constructing
>> the faulting pointer.
>> 
>> This patch does't use the generic decoder, and implements a limited
>> special-purpose decoder to decode MPX instructions, simply because
>> the generic decoder is very heavyweight not just in terms of
>> performance but in terms of interface -- because it has to.
> 
> My question still stands why using the existing decoder is an issue.
> Performance is a complete non issue in case of a bounds violation and
> the interface argument is just silly, really.
> 

As hpa said, we only need to decode several mpx instructions including BNDCL/BNDCU, and general decoder looks like a little heavy. Peter, what do you think about it?

Thanks,
Qiaowei

