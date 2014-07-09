Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaGIOce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:32:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:32888 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbaGIOcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="567385464"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Topic: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Index: AQHPmw42PYiPusxucki+Ie3j6NurFZuXRIqAgACHbiA=
Date: Wed, 9 Jul 2014 14:32:28 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709141631.GE9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140709141631.GE9918@twins.programming.kicks-ass.net>
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



> On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> > +/*
> > + * Under certain circumstances, access certain MSR may cause #GP.
> > + * The function tests if the input MSR can be safely accessed.
> > + */
> > +static inline bool check_msr(unsigned long msr) {
> > +	u64 value;
> > +
> > +	if (rdmsrl_safe(msr, &value) < 0)
> > +		return false;
> > +	if (wrmsrl_safe(msr, value) < 0)
> > +		return false;
> > +	return true;
> > +}
> 
> What does this thing return after patch 2? does the write still fault or will
> KVM silently take writes too?

If applying patch 2, the function will return true. The KVM just simply ignore the reads/writes.
