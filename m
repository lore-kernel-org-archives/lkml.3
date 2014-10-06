Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaJFHSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:18:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaJFHSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:18:32 -0400
Date: Mon, 6 Oct 2014 08:27:11 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141006072710.GH8971@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
 <20141005022311.GD8549@htj.dyndns.org>
 <20141005161646.GB22223@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005161646.GB22223@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 12:16:46PM -0400, Tejun Heo wrote:
> I think the thing which bothers me is that due to softirq we end up
> bouncing the context twice.  IRQ schedules threaded IRQ handler after
> doing minimal amount of work.  The threaded IRQ handler gets scheduled
> and again it doesn't do much but basically just schedules block
> softirq to actually run completions which is the heavier part.
> Apparently this doesn't seem to hurt measureably but it's just weird.

Hi Tejun,

That is exactly the point I was concerned with when stated in one of
changelogs "The downside of this change is introduction of a kernel
thread". Splitting the service routine in two parts is a small change
(in terms of code familiarity). Yet it right away provides benefits I
could observe and justify (to myself at least).

> Why are we bouncing the context twice?

I *did* consider moving the threaded handler code to the softirq part.
I just wanted to get updates in stages: to address hardware interrupts
latency first and possibly threaded hander next. Getting done these two
together would be too big change for me ;)

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
