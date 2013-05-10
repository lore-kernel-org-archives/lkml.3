Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3EJV6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:58:11 -0400
Received: from incomingmail.riverbed.com ([208.70.196.45]:40997 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3EJV6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:58:09 -0400
From: Ming Lei <Ming.Lei@riverbed.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0AACAr3gAAH652AAAiA5kA==
Date: Fri, 10 May 2013 21:58:08 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB84@SFO1EXC-MBXP06.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right, here is the boot information confirming this:
smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
smpboot: Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 OK
smpboot: Booting Node   0, Processors  #12 #13 #14 #15 #16 #17 OK
smpboot: Booting Node   1, Processors  #18 #19 #20 #21 #22 #23 OK

So only one socket gets the machine check. So is there still a problem but the fix will be different? I think the error inject creates a real machine check, but since each CPU has its own memory controller, the machine check may only send to the CPU the error happens.

Ming


-----Original Message-----
From: Luck, Tony [mailto:tony.luck@intel.com] 
Sent: Friday, May 10, 2013 2:05 PM
To: Ming Lei; linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com; bp@alien8.de
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of logical cores

> I used intel edac error injector and saw the same problem. I actually 
> wrote down the core numbers and I saw mce got to 0-5 and 12-17, but not the others. I have 2 sockets, 24 logical cores.

Mauro: How does the EDAC injector work on E5645 (Westmere-EP)?  Does it create a real error in memory that the processor then accesses ... tripping a machine check?

The mapping of Linux logical cpu numbers to physical socket/core/thread is somewhat as the mercy of the order that the BIOS lists things in its tables.  But those numbers look very much like you just saw the machine check on one socket.

Look at /proc/cpuinfo to be sure.  If you run "grep ^physical /proc/cpuinfo" I think you'll see output like this (confirming that only socket 0 saw the machine check):

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
