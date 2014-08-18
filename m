Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaHRPHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaHRPH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:07:29 -0400
Date: Mon, 18 Aug 2014 11:07:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 3/5] watchdog: fix print-once on enable
Message-ID: <20140818150722.GR49576@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-4-git-send-email-dzickus@redhat.com>
 <20140818090757.GC25495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818090757.GC25495@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:07:57AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -522,6 +522,9 @@ static void watchdog_nmi_disable(unsigned int cpu)
> >  		/* should be in cleanup, but blocks oprofile */
> >  		perf_event_release_kernel(event);
> >  	}
> > +	if (cpu == 0)
> > +		/* watchdog_nmi_enable() expects this to be zero initially. */
> > +		cpu0_err = 0;
> >  	return;
> >  }
> 
> While at it I also removed the stray 'return;'.

Doh, sorry about that.  Thanks!

Cheers,
Don
