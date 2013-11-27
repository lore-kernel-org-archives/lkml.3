Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3K0A3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:29:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:50009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3K0A30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,778,1378882800"; 
   d="scan'208";a="442715790"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: RE: Add memory barrier when waiting on futex
Thread-Topic: Add memory barrier when waiting on futex
Thread-Index: Ac7puzw8dEee+ztFRV6yZ2v5xXHPX///29EA//7QATCAAln+AP/+bUcQ
Date: Wed, 27 Nov 2013 00:28:22 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD0253020C@SHSMSX103.ccr.corp.intel.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
 <20131125143952.GB10022@twins.programming.kicks-ass.net>
 <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
 <20131126082626.GB789@laptop.programming.kicks-ass.net>
In-Reply-To: <20131126082626.GB789@laptop.programming.kicks-ass.net>
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


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, November 26, 2013 4:26 PM
> To: Ma, Xindong
> Cc: stable@vger.kernel.org; stable-commits@vger.kernel.org; Wysocki, Rafael
> J; ccross@google.com; tglx@linutronix.de; dvhart@linux.intel.com;
> mingo@kernel.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> Tu, Xiaobing
> Subject: Re: Add memory barrier when waiting on futex
> 
> On Tue, Nov 26, 2013 at 01:07:25AM +0000, Ma, Xindong wrote:
> > I've already aware that they've protected by spinlock, this is why I adding a
> memory barrier to fix it.
> 
> That doesn't make sense.. the spinlocks should provide the required
> serialization, there's nothing to fix.
> 
> > I reproduced this issue several times on android which running on IA dual
> core.
> 
> I think you need to be more specific, in particular, if spinlocks do not provide
> serialization on your IA32 device, I'd call that thing broken.
> Adding random memory barriers is _WRONG_.
> 
I agree with you. Thanks, Peter.
