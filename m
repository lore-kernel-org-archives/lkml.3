Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3LCTAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:00:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab3LCTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:00:44 -0500
Date: Tue, 3 Dec 2013 20:01:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Dyasly <dserrg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
Message-ID: <20131203190129.GA18159@redhat.com>
References: <20131202152423.GA10878@redhat.com> <20131203194635.7be1c07ae042ee395bc83527@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203194635.7be1c07ae042ee395bc83527@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

argh, sorry, I didn't finish my email...

On 12/03, Sergey Dyasly wrote:
>
> On Mon, 2 Dec 2013 16:24:23 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Recently people started to report they actually hit this problem in
> > oom_kill.c. This doesn't really matter and I can be wrong, but in
> > fact I do not think they really hit this race, it is very unlikely.
>
> The race is very easy to catch if you have a process with several threads,
> all of which allocates memory simultaneously. This leads to:
>
>   1) OOMk selects and sends SIGKILL to one of the threads
>
>   2) another thread invokes OOMk and the first thread gets selected,
>      but it gets unhashed before while_each_thread...

Yes, but this is what I meant.

It was unhashed before even while_each_thread(g), and it should be
never used unless you ensure that g is still alive.

But this doesn't matter. while_each_thread() was buggy anyway. And
(perhaps even more importantly) it was not easy to use it correctly,
so I finally decided to add another helper which only needs the
stable task_struct.

> The patches look correct and my test case no longer hangs, so
>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>

Thanks!

Oleg.

