Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaDXI23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:28:29 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53783 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaDXI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:28:24 -0400
Message-ID: <1398328099.6486.29.camel@marge.simpson.net>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Thu, 24 Apr 2014 10:28:19 +0200
In-Reply-To: <1398307888.26653.18.camel@marge.simpson.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
	 <1398307888.26653.18.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 04:51 +0200, Mike Galbraith wrote:

> Checking rq->lock for contention before ever going to idle balancing as
> well should give you a bit more.  No need to run around looking for work
> that's trying to arrive.  By not going there, perhaps stacking tasks,
> you may head off a future bounce as well.

Zzt.  Bailing without drop/retake to let work land would be a bad plan.

-Mike

