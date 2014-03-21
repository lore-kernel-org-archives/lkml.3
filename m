Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbaCUOkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:40:08 -0400
Received: from smtp4out.l-3com.com ([128.170.207.112]:61720 "EHLO
	smtp4out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaCUOkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:40:06 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 10:40:05 EDT
X-filenames: 
X-filesizes: None
X-filetypes: 
X-IronPort-AV: E=Sophos;i="4.97,704,1389744000"; 
   d="scan'208";a="218388464"
X-IronPort-AV: E=Sophos;i="4.97,704,1389765600"; 
   d="scan'208";a="5331188"
From: <jimmie.davis@l-3com.com>
To: <umgwanakikbuti@gmail.com>
CC: <artem_fetishev@epam.com>, <peterz@infradead.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAGlMAP//uUn5
Date: Fri, 21 Mar 2014 14:34:19 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E5925@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>,<1395407680.6030.81.camel@marge.simpson.net>
In-Reply-To: <1395407680.6030.81.camel@marge.simpson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [130.210.49.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Mike Galbraith [umgwanakikbuti@gmail.com]
Sent: Friday, March 21, 2014 8:14 AM
To: Davis, Bud @ SSG - Link
Cc: artem_fetishev@epam.com; peterz@infradead.org; kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
Subject: RE: Bug 71331 - mlock yields processor to lower priority process

On Fri, 2014-03-21 at 12:18 +0000, jimmie.davis@l-3com.com wrote:

> As the submitter of the bug, let me give you my perspective.
> SCHED_FIFO means run my task until it blocks or a higher priority task
> pre-empts it.  Period.

It blocked.
>
> mlock() doesn't block. check the man page.
>
I don't see that specified.

(or how it could be, but what do I know, IANIPL)

> Any other way and you are not able to use priority based scheduling.

Sure you can, allocate and lock down resources before entering critical
sections.

If you think donning a SCHED_FIFO super-suit should make your task
unstoppable, you're gonna be very disappointed.  Fact is if your
Juggernaut bumps ever so gently into a contended sleeping variety lock
(and in the rt kernel that means nearly every lock), it will block.

-Mike

------------------------------------------------------------------------------------------------
Mike,

There are several problem domains where you protect critical sections by assigning multiple
threads to a single CPU and use priorities and SCHED_FIFO to ensure data integrity.

In this kind of design you don't make many syscalls.  The ones you do make, have to be clearly understood
if they block.   

So, yes, I expect that a SCHED_FIFO task, that uses a subset of syscalls known to be non-blocking, will not block.  

If it is not 'unstoppable', then there is a defect in the OS.

In the past, a call to mlock() was known to be OK.  It would not block.  It might take a while, but it would run to completion.  It does not do that any more.

If mlock() is now a blocking call, then fine.  It only needs to be called on occasion, and this can be accounted for
in the application design.  Does write() block ?  Yes, the man pages talks all about it.  Does clock_gettime() block ?
No, blocking is not mentioned in the man page.  Blocking behaviour is rare, when it exists it is documented.

My point is, this is either a defect to be fixed, or a change that warrants updating the documentation.

regards,
Bud Davis

 







   

 










