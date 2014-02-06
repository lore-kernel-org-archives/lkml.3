Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaBFULI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:11:08 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15105 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBFULG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:11:06 -0500
From: "Norton, Scott J" <scott.norton@hp.com>
To: "Long, Wai Man" <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "Low, Jason" <jason.low2@hp.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Bueso, Davidlohr" <davidlohr@hp.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: RE: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Thread-Topic: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Thread-Index: AQHPHF0cp8t15pjM302Bqq3hOCL8MJqaoUqAgAAc+YCAANn2AIALpfcAgAER0ICAAE6BgIAAFPrQ
Date: Thu, 6 Feb 2014 20:10:02 +0000
Message-ID: <E2BC6EB51A09EC46A4906DEA4A9496EE0B7077AA@G9W0719.americas.hpqcorp.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <52F2B0C2.8040408@hp.com>
 <20140206140435.GU8874@twins.programming.kicks-ass.net>
 <52F3D84D.5060309@hp.com>
In-Reply-To: <52F3D84D.5060309@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.28]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I run the patch through the AIM7 high-systime workload on a
>> 4-socket server and it seemed to run fine.
> How do people run this AIM7 piece of shit? I let it run for over an hour
> and it generated exactly 0 numbers, it just sits there eating cpu-time
> and creating a racket from my pantry.

./reaim -s100  -e2000 -t -j100 -i100 -f workfile.high_systime

The reaim.config file contains:

FILESIZE 10k
POOLSIZE 1m
DISKDIR /t0
DISKDIR /t1
DISKDIR /t2
DISKDIR /t3
DISKDIR /t4
DISKDIR /t5
DISKDIR /t6
DISKDIR /t7
DISKDIR /t8
DISKDIR /t9
DISKDIR /t10
DISKDIR /t11
DISKDIR /t12
DISKDIR /t13
DISKDIR /t14
DISKDIR /t15

The way Longman uses this is to create 16 ramdisk filesystems through
/dev/ram* and then mount those filesystems to the /t* directories.
Although you could run it through a regular filesystem also. It will use
whatever you place in the reaim.config file as DISKDIR. You can specify
one or more DISKDIR directories.


Scott

