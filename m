Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaIKMXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:23:52 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:51964 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaIKMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:23:50 -0400
Date: Thu, 11 Sep 2014 07:23:45 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, prarit@redhat.com, jgh@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH v2 1/3] init/main.c: Give init_task a canary
Message-ID: <20140911072345.012f4ef3@as>
In-Reply-To: <20140910132933.GG1436@atomlin.usersys.redhat.com>
References: <20140904161124.GD1436@atomlin.usersys.redhat.com>
	<1410255749-2956-1-git-send-email-atomlin@redhat.com>
	<1410255749-2956-2-git-send-email-atomlin@redhat.com>
	<20140910022654.29abc9f3@as>
	<20140910132933.GG1436@atomlin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 14:29:33 +0100
Aaron Tomlin <atomlin@redhat.com> wrote:

> On Wed, Sep 10, 2014 at 02:26:54AM -0500, Chuck Ebbert wrote:
> > And has this been tested on parisc and metag, which use STACK_GROWSUP ?
> > I can't see how end_of_stack() as it's defined now could work on those archs.
> 
> AFAIU, dup_task_struct() has always done this explicitly.
> I see no reason why init_task requires special attention.
> 

I guess what I'm saying is, I can't see how the stack canary could have ever
detected any problems on parisc and metag. How did you test your patches on x86?
Maybe someone could run tests on those other archs.
