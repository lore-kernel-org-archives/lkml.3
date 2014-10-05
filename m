Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaJEQQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:16:53 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42930 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaJEQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:16:50 -0400
Date: Sun, 5 Oct 2014 12:16:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141005161646.GB22223@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
 <20141005022311.GD8549@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005022311.GD8549@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of addition.

On Sat, Oct 04, 2014 at 10:23:11PM -0400, Tejun Heo wrote:
> Hmmm.... so, AFAICS, there's no real pros or cons of going either way,
> right?  The only thing which could be different is possibly slightly
> lower latency in servicing other IRQs or RT tasks on the same CPU but
> given that the ahci IRQ handler already doesn't do anything which
> takes time, I'm doubtful whether that'd be anything measureable.
> 
> I just don't get why ahci bothers with threaded irq, MMSI or not.

I think the thing which bothers me is that due to softirq we end up
bouncing the context twice.  IRQ schedules threaded IRQ handler after
doing minimal amount of work.  The threaded IRQ handler gets scheduled
and again it doesn't do much but basically just schedules block
softirq to actually run completions which is the heavier part.
Apparently this doesn't seem to hurt measureably but it's just weird.
Why are we bouncing the context twice?

Thanks.

-- 
tejun
