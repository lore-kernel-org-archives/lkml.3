Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaFBQWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:22:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:32832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbaFBQWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,957,1392192000"; 
   d="scan'208";a="439902018"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, "Chen, Gong" <gong.chen@linux.intel.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Thread-Topic: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Thread-Index: AQHPeilSOyJTIZwXt0erLrK7gz6USJtWk/0AgAASiACAAAYGgIACpdkAgAAMgACAAGDh4IAAmseAgAOtDFA=
Date: Mon, 2 Jun 2014 16:22:19 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
 <20140530210759.267a854e@gandalf.local.home>
In-Reply-To: <20140530210759.267a854e@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> All of this stuff only applies to server systems - so quibbling over
>> a handful of *bytes* in an error record on a system that has tens,
>> hundreds or even thousands of *gigabytes* of memory seems
>> a bit pointless.
>
> But there's still only a limited number of bytes in the ring buffer no
> matter what the system, thus we still need to quibble over it.

To which I'll counter that the trace ring buffer can handle tracing of
events like page faults and context switches (can't it?) that happen
at a rate of thousands per second.  Our eMCA records will normally
happen at a rate of X per month (where X may well be less than one).
If there is a storm of errors - we disable CMCI interrupts and revert
to polling.  We declare a "storm" as just 15 events in a second. If we
switch to polling, then we won't poll faster than once per second.

So worst case is that we are seeing some steady flow of events that
don't quite trigger the storm detector ... about 14 events per second.

-Tony
