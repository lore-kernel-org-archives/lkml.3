Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaBZJHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:07:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38571 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaBZJHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:07:06 -0500
Date: Wed, 26 Feb 2014 10:07:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: tkhai@yandex.ru, Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/rt: fix rt timer activation/deactivation
Message-ID: <20140226090700.GG18404@twins.programming.kicks-ass.net>
References: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
 <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
 <1393382258.5142.4.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393382258.5142.4.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 03:37:38AM +0100, Mike Galbraith wrote:
> BTW, I noticed you can no longer turn the turn the noisy thing off since
> we grew DL.  I added an old SGI boot parameter to tell it to go away.

You're talking about the rt badnwidth timer, right?

 1) why won't it go away with DL added?

 2) it should never appear when !rt_bandwidth_enabled(), so if you set
 sysctl_sched_rt_runtime to -1 all this should go away already, no extra
 patches required.


