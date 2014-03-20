Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbaCTSuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbaCTSuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:50:22 -0400
Date: Thu, 20 Mar 2014 19:49:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140320184904.GA10194@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com> <20140318162319.GB5669@redhat.com> <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com> <20140319173330.GA11923@redhat.com> <CF4F4C6F.9A880%andreas.dilger@intel.com> <20140319195520.GF8557@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319195520.GF8557@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Peter Zijlstra wrote:
>
> On Wed, Mar 19, 2014 at 07:44:29PM +0000, Dilger, Andreas wrote:
> > The original reason for l_wait_event() not using TASK_UNINTERRUPTIBLE
> > is to avoid the load on the server continually being "num_service_threads"
> > regardless of whether they are actually doing something or not.  We
> > added various cases for periodic wakeups and such afterward.
>
> Hmm, maybe we should finally do the TASK_IDLE thing;
>
>   https://lkml.org/lkml/2013/11/12/710

Agreed. And if we are not going to expose TASK_IDLE bit in /proc/ (I think
we should not) the patch should be really trivial.

Oleg.

