Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbaCUNOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:14:43 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63065 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760874AbaCUNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:14:41 -0400
Message-ID: <1395407680.6030.81.camel@marge.simpson.net>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: jimmie.davis@l-3com.com
Cc: artem_fetishev@epam.com, peterz@infradead.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 14:14:40 +0100
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

