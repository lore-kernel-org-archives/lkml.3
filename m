Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaJFM6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:58:23 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:61342 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaJFM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:58:20 -0400
Date: Mon, 6 Oct 2014 08:58:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141006125817.GA18303@htj.dyndns.org>
References: <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
 <20141005022311.GD8549@htj.dyndns.org>
 <20141005161646.GB22223@mtj.dyndns.org>
 <20141006072710.GH8971@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006072710.GH8971@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Mon, Oct 06, 2014 at 08:27:11AM +0100, Alexander Gordeev wrote:
> > Why are we bouncing the context twice?
> 
> I *did* consider moving the threaded handler code to the softirq part.
> I just wanted to get updates in stages: to address hardware interrupts
> latency first and possibly threaded hander next. Getting done these two
> together would be too big change for me ;)

I don't think we'd be able to move libata handling to block softirq
and probably end up just doing it from the irq context.  Anyways, as
long as you're gonna keep working on it, I have no objection to the
proposed changes.  Do you have a refreshed version or is the current
version good for inclusion?

Thanks.

-- 
tejun
