Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3IET4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:56:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:3781 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3IET4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:56:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,849,1371106800"; 
   d="scan'208";a="374074804"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lockref: remove cpu_relax() again
Thread-Topic: [PATCH] lockref: remove cpu_relax() again
Thread-Index: AQHOqjponYZ6pHUzoUeo27Wv6BHm9pm3utOA//+oSZCAAH9VgP//mtyggAB9vgD//5CLAAAO9roAAA6RDoA=
Date: Thu, 5 Sep 2013 19:56:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CDCDB2@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
	<CA+55aFw_Rovv7YTb62q5NQvucM5ks8+HXcsTOJ-oJ+kqmHop4A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCCFA@ORSMSX106.amr.corp.intel.com>
 <CA+55aFy0BZ8kL0TMgV+u1g5Rt=hBJw44+kps5RzD-s=Uo-zsLg@mail.gmail.com>
In-Reply-To: <CA+55aFy0BZ8kL0TMgV+u1g5Rt=hBJw44+kps5RzD-s=Uo-zsLg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r85JukHD032628

> That said, another thing that strikes me is that you have 32 CPU
> threads, and the stupid test-program I sent out had MAX_THREADS set to
> 16.  Did you change that? Becuase if not, then some of the extreme
> performance profile might be about how the threads get scheduled on
> your machine (HT threads vs full cores etc).

I'll try to get new numbers with 32 threads[*] - but even if they look good, I'd
be upset about the 16 thread case being worse with the cmpxchg/no-cpu-relax
case than the original code.

-Tony

[*] probably not till tomorrow
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
