Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3EJTJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:09:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:56036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3EJTJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:09:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,650,1363158000"; 
   d="scan'208";a="300621511"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ming Lei <Ming.Lei@riverbed.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0A==
Date: Fri, 10 May 2013 19:09:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
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

> With hyperthread turns on, the num_online_cpus reports the number of all logical cores.
> What I found in testing is only half the cores receives the mce broadcast, so I assume only the physical cores get broadcast.

See Intel Software Developer Manual Volume 3B Section 15.10.4.1, 3rd bullet:

   o For processors on which CPUID reports DisplayFamily_DisplayModel as 06H_0EH and onward, an MCA signal is
      broadcast to all logical processors in the system

Your E-5645 processors are a lot newer than this cut-off version - so they should broadcast
to all your threads.

You are seeing something very strange.  It would be interesting to know *which* 12 cpus
show up for your machine check.  Perhaps you are seeing all the hyperthreads from one
socket and none from the other?

I still suspect that something is strange in the EDAC error injection side of this problem
and that you are not getting a h/w initiated INT#18 event.

-Tony

