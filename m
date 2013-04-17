Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005Ab3DQHvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:51:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60076 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965738Ab3DQHu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:50:59 -0400
Date: Wed, 17 Apr 2013 09:50:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/3] mutex: Queue mutex spinners with MCS lock to
 reduce cacheline contention
Message-ID: <20130417075055.GC31607@gmail.com>
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
 <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
 <20130416091026.GB9569@gmail.com>
 <516D5F97.9050203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D5F97.9050203@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> > I'd suggest a preparatory patch that gets rid of that flag and moves these two
> > functions from sched/core.c to mutex.c where they belong.
> >
> > This will also allow the removal of the mutex prototypes from sched.h.
> 
> Yes, I can certainly prepare a patch to remove SCHED_FEAT_OWNER_SPIN & move 
> those functions back to mutex.c after my patch set goes in. As for the timing, 
> do you want me to do it now or it can wait as I will start my vacation later 
> this week and will be back by the end of the month.

I'd suggest waiting with the latest series until you are back, so that you can 
address regressions, should there be any.

Thanks,

	Ingo
