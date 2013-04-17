Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3DQE50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3DQE5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:57:25 -0400
Date: Wed, 17 Apr 2013 06:57:03 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130417045703.GA29524@host2.jankratochvil.net>
References: <20130414191205.GA28791@redhat.com>
 <20130415233652.GE17561@somewhere.redhat.com>
 <20130416132545.GA9189@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416132545.GA9189@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 15:25:45 +0200, Oleg Nesterov wrote:
> On 04/16, Frederic Weisbecker wrote:
> > On Sun, Apr 14, 2013 at 09:12:05PM +0200, Oleg Nesterov wrote:
> > Looking at the bug report, it seems they only reproduced with a homemade
> > test. No real app has reported that issue?
> 
> iirc (Jan can correct me) gdb hit this problem, but it was already
> changed to change DR0 first.

Both old GDB and recent GDB handle it correctly (DR0 first, then DR7).

I do not remember how but I have hit this issue, probably during development
of the GDB watchpoint code, there were many variants of it in the past.

So it was not found just by an artificial testing.

My concern was not so much about GDB but rather about possible other existing
debugging/tracing software using DR.


Jan
