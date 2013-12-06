Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300Ab3LFWMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:12:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:26893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161319Ab3LFWMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:12:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="420690376"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: RE: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Topic: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Index: AQHO8sraYnj+nqsDeUCT31iTRUZtSppHuTFQ
Date: Fri, 6 Dec 2013 22:12:30 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350140BB62@SHSMSX101.ccr.corp.intel.com>
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>
	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com>
 <52A20AD6.8080706@redhat.com>
 <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com>
 <52A242BE.3010701@zytor.com>
In-Reply-To: <52A242BE.3010701@zytor.com>
Accept-Language: en-US
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

H. Peter Anvin wrote:
> On 12/06/2013 12:05 PM, Liu, Jinsong wrote:
>>> 
>>> Since Peter already said the same, please undo these changes.
>>> 
>>> Also, how is XSTATE_EAGER used?  Should MPX be disabled when
>>> xsaveopt is disabled on the kernel command line?  (Liu, how would
>>> this affect the KVM patches, too?) 
>>> 
>>> Paolo
>> 
>> Currently seems no, and if needed we can add a new patch at kvm side
>> accordingly when native mpx patches checked in. 
>> 
> 
> We need to either disable these features in lazy mode, or we need to
> force eager mode if these features are to be supported.  The problem
> with the latter is that it means forcing eager mode regardless of if
> anything actually *uses* these features.
> 
> A third option would be to require applications to use a prctl() or
> similar to enable eager-save features.
> 
> Thoughts?
> 
> 	-hpa

The third option seems better -- how does native mpx patches work, force eager?

Thanks,
Jinsong