Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbaCUOvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:51:21 -0400
Received: from smtp2out.l-3com.com ([166.20.51.112]:6755 "EHLO
	smtp2out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaCUOvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:51:16 -0400
X-filenames: 
X-filesizes: None
X-filetypes: 
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,704,1389744000"; 
   d="scan'208";a="226562700"
X-IronPort-AV: E=Sophos;i="4.97,704,1389765600"; 
   d="scan'208";a="5331384"
From: <jimmie.davis@l-3com.com>
To: <umgwanakikbuti@gmail.com>
CC: <oneukum@suse.de>, <artem_fetishev@epam.com>, <peterz@infradead.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAG8YgP//rVNFgABlNQD//6xjLQ==
Date: Fri, 21 Mar 2014 14:50:34 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395408925.9455.3.camel@linux-fkkt.site>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>,<1395412904.6030.126.camel@marge.simpson.net>
In-Reply-To: <1395412904.6030.126.camel@marge.simpson.net>
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
Sent: Friday, March 21, 2014 9:41 AM
To: Davis, Bud @ SSG - Link
Cc: oneukum@suse.de; artem_fetishev@epam.com; peterz@infradead.org; kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
Subject: RE: Bug 71331 - mlock yields processor to lower priority process

On Fri, 2014-03-21 at 14:01 +0000, jimmie.davis@l-3com.com wrote:

> If you call mlock () from a SCHED_FIFO task, you expect it to return
> when done.  You don't expect it to block, and your task to be
> pre-empted.

Say some of your pages are sitting in an nfs swapfile orbiting Neptune,
how do they get home, and what should we do meanwhile?

-Mike

Two options.

#1. Return with a status value of EAGAIN.

or 

#2.  Don't return until you can do it.

If SCHED_FIFO is used, and mlock() is called, the intention of the user is very clear.  Run this task until
it is completed or it blocks (and until a bit ago, mlock() did not block).

SCHED_FIFO users don't care about fairness.  They want the system to do what it is told.

regards,
Bud Davis




 
 

 
