Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaHPHkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 03:40:35 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50933 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaHPHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 03:40:34 -0400
Message-ID: <1408174826.5575.33.camel@marge.simpson.net>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Sat, 16 Aug 2014 09:40:26 +0200
In-Reply-To: <53EE4A31.5080407@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
	 <1407125450.4710.38.camel@j-VirtualBox> <53DFAA53.4010003@hp.com>
	 <20140813055153.GD20518@dastard> <53EB9522.2070804@hp.com>
	 <20140815033447.GJ20518@dastard> <53EE4A31.5080407@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-15 at 13:58 -0400, Waiman Long wrote:

> Thank for the testing recipe. I am afraid that I can't find a 500TB SSD 
> for testing purpose. Do you think the test will still be valid for 
> exercising rwsem if I use a smaller SSD or maybe mechanical hard disk?

I suspect fs_mark will fit in less than a cubic meter of silicon.  You
definitely don't want to use a 400GB USB2 drive to find out though. 

FSUse%        Count         Size    Files/sec     App Overhead
     0       800000            0      22474.9          5551907
     0      1600000            0       1550.0        314304154
     0      2400000            0        832.3        928216719

zzzzz... nope, nobody is _that_ bored ^C 

(starts xfs_repair, perf top.. snort)

Nope, you definitely don't want USB2 crapware for that either :)

	-Mike

