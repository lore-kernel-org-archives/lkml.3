Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaFRElc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:41:32 -0400
Received: from ozlabs.org ([103.22.144.67]:33157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572AbaFREla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:41:30 -0400
Message-ID: <1403066487.32307.4.camel@concordia>
Subject: Re: [RESEND] shm: shm exit scalability fixes
From: Michael Ellerman <mpe@ellerman.id.au>
To: Anton Blanchard <anton@samba.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jack Miller <millerjo@us.ibm.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        miltonm@us.ibm.com
Date: Wed, 18 Jun 2014 14:41:27 +1000
In-Reply-To: <20140618125329.1f8cd8f9@kryten>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
	 <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
	 <20140618125329.1f8cd8f9@kryten>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 12:53 +1000, Anton Blanchard wrote:
> > I normally wouldn't mind optimizing synthetic cases like this, but a
> > quick look at patch 1/3 shows that we're adding an extra overhead (16
> > bytes) in the task_struct.
> 
> > We have the shmmni limit (and friends) for that.
> 
> If we want to use this to guard against the problem, we may need to
> drop shmmni. Looking at my notes, I could take down a box with 4096
> segments and 16 threads. This is where I got to before it disappeared:
> 
> # ./bust_shm_exit 4096 16
> # uptime
> 03:00:50 up 8 days, 18:05  5 users,load average: 6076.98, 2494.09, 910.37

I win, using 4096 segments and 16 threads:

 # uptime
 13:50:46 up 1 day, 19:41,  2 users,  load average: 7621.57, 1718.39, 943.13
 13:52:35 up 1 day, 19:43,  2 users,  load average: 15422.64, 7409.90, 3156.82

That's on a 16 cpu box running 3.16-rc1.

In contrast, if you run it with 1 segment and 16 threads it maxes out about:

 # uptime
 13:58:00 up 1 min,  2 users,  load average: 1.81, 0.46, 0.15

And the box is entirely responsive.

cheers


