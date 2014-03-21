Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbaCUPZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:25:13 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:46796 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbaCUPZL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:25:11 -0400
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 11:25:11 EDT
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: "jimmie.davis@l-3com.com" <jimmie.davis@l-3com.com>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>
CC: "artem_fetishev@epam.com" <artem_fetishev@epam.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2014 07:54:46 -0700
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAGlMAP//uUn5gAALcuA=
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E3097689471@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>,<1395407680.6030.81.camel@marge.simpson.net>
 <FFF95760268D324AB6DD9426E83C8DF70B2E5925@ARLEXCHMBX01.lst.link.l-3com.com>
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E5925@ARLEXCHMBX01.lst.link.l-3com.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-21_04:2014-03-21,2014-03-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mike,
> 
> There are several problem domains where you protect critical sections by assigning multiple threads to a single CPU and use priorities
> and SCHED_FIFO to ensure data integrity.
> 
> In this kind of design you don't make many syscalls.  The ones you do make, have to be clearly understood
> if they block.
> 
> So, yes, I expect that a SCHED_FIFO task, that uses a subset of syscalls known to be non-blocking, will not block.
> 
> If it is not 'unstoppable', then there is a defect in the OS.
> 
> In the past, a call to mlock() was known to be OK.  It would not block.  It might take a while, but it would run to completion.  It does not
> do that any more.

False. Mlock is blockable since it was born.
Mlock and mlockall need memory allocate by definition. And it could lead to run VM activity and it may block. At least, on Linux.

lru_add_drain_all() is not only place to wait. Even if we remove it, mlock can still block. I don't think this discussion make sense.

> If mlock() is now a blocking call, then fine.  It only needs to be called on occasion, and this can be accounted for in the application

Now? I have not seen any recent change.

Note: I'm not sure Artem's use-case is good or bad.  I only say the false assumption don't make a good discussion.

