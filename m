Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbaCUOBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:01:50 -0400
Received: from smtp2out.l-3com.com ([166.20.51.112]:6893 "EHLO
	smtp2out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaCUOBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:01:47 -0400
X-filenames: 
X-filesizes: None
X-filetypes: 
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,704,1389744000"; 
   d="scan'208";a="226553183"
X-IronPort-AV: E=Sophos;i="4.97,704,1389765600"; 
   d="scan'208";a="5330755"
From: <jimmie.davis@l-3com.com>
To: <oneukum@suse.de>
CC: <umgwanakikbuti@gmail.com>, <artem_fetishev@epam.com>,
        <peterz@infradead.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAG8YgP//rVNF
Date: Fri, 21 Mar 2014 14:01:03 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>,<1395408925.9455.3.camel@linux-fkkt.site>
In-Reply-To: <1395408925.9455.3.camel@linux-fkkt.site>
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
From: Oliver Neukum [oneukum@suse.de]
Sent: Friday, March 21, 2014 8:35 AM
To: Davis, Bud @ SSG - Link
Cc: umgwanakikbuti@gmail.com; artem_fetishev@epam.com; peterz@infradead.org; kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
Subject: Re: Bug 71331 - mlock yields processor to lower priority process

On Fri, 2014-03-21 at 12:18 +0000, jimmie.davis@l-3com.com wrote:
>
> >How is that different from any other time a task has to yield the CPU
> >for a bit?  While your high priority task is blocked for whatever
> >reason, a lower priority task gets to use the CPU.
>
>
> As the submitter of the bug, let me give you my perspective.  SCHED_FIFO means run my task until it blocks or a higher priority task pre-empts it.  Period.
>
> mlock() doesn't block.  check the man page.

It guarantees that all pages be in RAM. That means it has to read them
in if they aren't. How could it do that without blocking?

        Regards
                Oliver
------------------------------------------------------------------------------------------
Oliver,

I would assume it would touch some flag bits on every page.  As part of the thread of execution that called it.

If you call mlock () from a SCHED_FIFO task, you expect it to return when done.  You don't expect it to block, and your task to be pre-empted.

For many years it returned when finished.  Now, it blocks.

This makes code that used to work, not work.  

I consider it a defect.

regards,
Bud Davis 



 




 


