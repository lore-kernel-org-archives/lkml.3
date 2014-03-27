Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaC0Ffj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:35:39 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33695 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaC0Ffi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:35:38 -0400
Message-ID: <1395898535.5512.72.camel@marge.simpson.net>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: jimmie.davis@l-3com.com
Cc: luto@amacapital.net, oneukum@suse.de, artem_fetishev@epam.com,
        peterz@infradead.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Mar 2014 06:35:35 +0100
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E725C@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395408925.9455.3.camel@linux-fkkt.site>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395412904.6030.126.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
	 <5333734E.2020600@mit.edu>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E725C@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-27 at 04:20 +0000, jimmie.davis@l-3com.com wrote: 


> The example code submitted into bugzilla (chase back on the thread a
> bit, there is a reference) shows the problem.
> 
> Two threads, TaskA (high priority) and TaskB (low priority).  Assigned
> to the same processor, explicitly for the guarantee that only one of
> them can execute at a time.

Your priority based serialization guarantee does not exist.  Tasks can
be and are put to sleep.  When that happens, a lower priority runnable
task will run.  Whether you like that fact or not, it remains a fact.

If you don't want your lower priority task to run, why do you wake it?.

-Mike
> 


