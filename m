Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaJECXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 22:23:17 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:63181 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJECXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 22:23:14 -0400
Date: Sat, 4 Oct 2014 22:23:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141005022311.GD8549@htj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001153114.GE8971@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alexander.

On Wed, Oct 01, 2014 at 04:31:15PM +0100, Alexander Gordeev wrote:
> As of your concern wrt threaded handler invocation overhead - I am
> not quite sure here, but if SCHED_FIFO policy (the handler runs with)
> makes the difference? Anyway, as said above the overall IO does not
> suffer.

Hmmm.... so, AFAICS, there's no real pros or cons of going either way,
right?  The only thing which could be different is possibly slightly
lower latency in servicing other IRQs or RT tasks on the same CPU but
given that the ahci IRQ handler already doesn't do anything which
takes time, I'm doubtful whether that'd be anything measureable.

I just don't get why ahci bothers with threaded irq, MMSI or not.

Thanks.

-- 
tejun
