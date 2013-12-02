Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3LBPds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab3LBPdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:33:47 -0500
Date: Mon, 2 Dec 2013 16:34:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
Message-ID: <20131202153418.GA11061@redhat.com>
References: <20131202152423.GA10878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202152423.GA10878@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Oleg Nesterov wrote:
>
> The lockless while_each_thread() is racy and broken, almost
> every user can loop forever.
> ...
> Another problem with while_each_thread() is that it is very easy
> to use it wrongly, and oom_kill.c is the good example.

Forgot to mention, it is not necessarily safe even under task
list lock if it is used wrongly. Again, oom_kill.c is the good
example, oom_kill_process() does read_lock(&tasklist_lock) but
it doesn't verify that p is still alive.

The new for_each_thread() is much simpler in this respect, it
only needs the stable task_struct.

Oleg.

