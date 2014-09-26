Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaIZLbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:31:41 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56071 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaIZLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:31:39 -0400
Date: Fri, 26 Sep 2014 13:31:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
Message-ID: <20140926113134.GA14072@gmail.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
 <1411491764.3922.46.camel@hornet>
 <20140924074942.GB3797@gmail.com>
 <1411665649.4768.84.camel@hornet>
 <20140925183342.GB6854@gmail.com>
 <1411728487.3852.9.camel@hornet>
 <20140926112312.GB9870@gmail.com>
 <1411730797.3852.23.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730797.3852.23.camel@hornet>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pawel Moll <pawel.moll@arm.com> wrote:

> On Fri, 2014-09-26 at 12:23 +0100, Ingo Molnar wrote:
> > > As in: allows *all* tasks to inject the data? Are you sure we 
> > > don't want more fine-grained control, in particular per task?
> > 
> > Yeah. If the profiler allows it, then any task that is being 
> > traced can inject data.
> 
> The "that is being traced" fragment was the key here. I missed 
> the fact that perf trace already takes a list of pids, so we're 
> not talking about all tasks in the system. That should work.

Yeah, when we generate a user trace event, we should look at the 
currently active perf context's (percpu ones plus task ones), and 
inject into those only.

This way we limit event generation to those buffers that are 
actively interested in this task.

Thanks,

	Ingo
