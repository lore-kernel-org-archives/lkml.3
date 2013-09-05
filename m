Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3IERNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:13:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3IERM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:12:59 -0400
Date: Thu, 5 Sep 2013 19:12:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
Message-ID: <20130905171255.GA30176@gmail.com>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <20130902065512.GA29060@gmail.com>
 <20130905131502.GA26387@gmail.com>
 <20130905151034.GP19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905151034.GP19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> The correct way is to implement it like TopDown level 1, but I don't 
> know how to put that into the kernel.

Create an event group, with some callbacks to do the 
additions/subtractions to get at the right figures? (if it's plain linear 
arithmetics then that could be encoded in some simple operation flags as 
well, executed and calculated when the group count is accessed.)

That's something that would be useful to have in the kernel anyway, to 
abstract away simple concepts that are not so simple to measure.

> http://software.intel.com/en-us/articles/how-to-tune-applications-using-a-top-down-characterization-of-microarchitectural-issues
> 
> It requires running 4 counters and computing some equations.
>
> My toplev tool in http://github.com/andikleen/pmu-tools has a 
> implementation on top of perf.
> 
> I could put it into perf stat if you want, but it would be somewhat 
> Intel specific.

Yeah, would be nice to hide this mostly transparently, behind a group of 
events or so.

Thanks,

	Ingo
