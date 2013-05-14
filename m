Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3ENA5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:57:51 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61337 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3ENA5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:57:49 -0400
Date: Tue, 14 May 2013 02:57:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
Message-ID: <20130514005744.GA12749@somewhere>
References: <1368346669.5998.13.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368346669.5998.13.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 10:17:49AM +0200, Mike Galbraith wrote:
> Greetings,
> 
> Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
> accrue zero utime/stime.  However, the same exact kernel on E5620 box
> works fine, so it would appear there's a CPU dependency somewhere.

Ah indeed, I just managed to reproduce the same issue.

> 
> Is core2 expected to go dysfunctional with context tracking enabled?
> CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
> CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
> boxen only, same exact kernel continues to work just fine on E5620
> (Westmere) box.

There was no known issue with core2. The box where I'm seeing the it
is a Phenom quad core that had NR_CPUS=2. May be the issue is more
likely to happen with this low number. I don't know.

I'm investigating further.

Thanks.
