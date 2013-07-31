Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab3GaLwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab3GaLwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:52:46 -0400
Date: Wed, 31 Jul 2013 13:47:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes
	and ftrace function hash fixes
Message-ID: <20130731114722.GA4416@redhat.com>
References: <20130730112718.273490378@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730112718.273490378@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Steven Rostedt wrote:
>
> Using the i_private and event_mutex
> to verify that the event still exists to solve the race.

To remind, we also need the "debugfs: debugfs_remove_recursive() must
not rely on list_empty(d_subdirs)" patch, otherwise we still have the
problems with the opened files.

Just in case, we need this fix even if .open() does trace_array_get()
or tracing_open_generic_file() (removed by recent changes), rmdir can
be called before we increment the counter and the deleted dentry breaks
debugfs_remove_recursive().

But after the recent changes this fix becomes more important. An opened
file confuses debugfs_remove_recursive() and after that you can't create
another probe.

Oleg.

