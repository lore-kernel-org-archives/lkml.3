Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3EJVEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:04:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:42909 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab3EJVEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:04:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="332178441"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ming Lei <Ming.Lei@riverbed.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0AACAr3gAAH652A=
Date: Fri, 10 May 2013 21:04:44 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
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

> I used intel edac error injector and saw the same problem. I actually wrote down the core numbers
> and I saw mce got to 0-5 and 12-17, but not the others. I have 2 sockets, 24 logical cores. 

Mauro: How does the EDAC injector work on E5645 (Westmere-EP)?  Does it create a real
error in memory that the processor then accesses ... tripping a machine check?

The mapping of Linux logical cpu numbers to physical socket/core/thread is somewhat
as the mercy of the order that the BIOS lists things in its tables.  But those numbers look
very much like you just saw the machine check on one socket.

Look at /proc/cpuinfo to be sure.  If you run "grep ^physical /proc/cpuinfo" I think you'll
see output like this (confirming that only socket 0 saw the machine check):

physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  0
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
physical id     :  1
