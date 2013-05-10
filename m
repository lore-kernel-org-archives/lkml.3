Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3EJWmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 18:42:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:18702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3EJWmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 18:42:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="239863346"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ming Lei <Ming.Lei@riverbed.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0AACAr3gAAH652AAAiA5kAAA3IFQ
Date: Fri, 10 May 2013 22:41:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA4CD58@ORSMSX106.amr.corp.intel.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB84@SFO1EXC-MBXP06.nbttech.com>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB84@SFO1EXC-MBXP06.nbttech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So only one socket gets the machine check. So is there still a problem but the fix will be different?
> I think the error inject creates a real machine check, but since each CPU has its own memory controller,
> the machine check may only send to the CPU the error happens.

If there is a real machine check, then it must go to all logical cpus. If it doesn't get there, then there
is a h/w (or possibly f/w configuration) problem.  Interesting that few others have seen this. Perhaps
because it only shows up in a fatal path and the machine is crashing anyway.  A Google search for
the "Some CPUs didn't answer in synchronization" message does have a few hits that look relevant,
but following a few didn't give me enough details on machine configuration to tell whether they
match what you are seeing.

If there are many machines that do this - then we may need a workaround in Linux code for them.
Who is the manufacturer of the motherboard and/or system you are using?

But the current code that expects to see the machine check on all logical cpus is correct (and works
as is on other machines that are following the specification).

-Tony


