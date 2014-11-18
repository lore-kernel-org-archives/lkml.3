Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaKRJ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:58:00 -0500
Received: from mx0.aculab.com ([213.249.233.131]:45925 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753066AbaKRJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:57:56 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexander Duyck'" <alexander.h.duyck@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mathieu.desnoyers@polymtl.ca" <mathieu.desnoyers@polymtl.ca>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "mikey@neuling.org" <mikey@neuling.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "matthew.vick@intel.com" <matthew.vick@intel.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "romieu@fr.zoreil.com" <romieu@fr.zoreil.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/4] Add lightweight memory barriers fast_rmb() and
 fast_wmb()
Thread-Topic: [PATCH 0/4] Add lightweight memory barriers fast_rmb() and
 fast_wmb()
Thread-Index: AQHQAorfzFQVR/NlWkyw/QBPbdjyr5xmJZCg
Date: Tue, 18 Nov 2014 09:57:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F2930@AcuExch.aculab.com>
References: <20141117171005.22333.96544.stgit@ahduyck-server>
In-Reply-To: <20141117171005.22333.96544.stgit@ahduyck-server>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAI9w5Og019458

From: Alexander Duyck
> These patches introduce two new primitives for synchronizing cache-enabled
> memory writes and reads.  These two new primitives are:
> 
> 	fast_rmb()
> 	fast_wmb()

Not sure I like the names.
If the aim is to sync data into the local cache so that hardware
that is doing cache-snooping accesses sees the data then maybe
	local_rmb() and local_wmb()

IIRC read_barrier_depends() is a nop on everything except alpha.
Maybe add the default if it isn't defined by the MD file?

	David
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
