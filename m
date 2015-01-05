Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbbAEKtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:49:17 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39938 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbbAEKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:49:16 -0500
Message-ID: <1420454949.5266.138.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH 0/3] sched: skip_clock_update madness
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Date: Mon, 05 Jan 2015 11:49:09 +0100
In-Reply-To: <20150105101809.860964488@infradead.org>
References: <20150105101809.860964488@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 11:18 +0100, Peter Zijlstra wrote: 
> Hi,
> 
> So the big lockup thread got me looking at the skip_clock_update stuff again
> and here's what I came up with.
> 
> It seems to build a kernel without generating lockdep splats.
> 
> Mike can you see if it cures the wobblies you were seeing?

Nope, those hiccups were production IO beasts from hell staying in the
kernel for ages at a time.  Watchdog being falsely credited with what is
usually dinky wakeup -> switch delta throttled it effectively forever.

-Mike  


