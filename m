Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaKWS1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaKWS1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:27:14 -0500
Date: Sun, 23 Nov 2014 19:26:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>
Subject: Re: task_stat splat
Message-ID: <20141123182637.GA15568@redhat.com>
References: <20141123111220.GA6436@pd.tnic> <20141123172256.GA9625@redhat.com> <20141123174604.GA4054@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123174604.GA4054@pd.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Borislav Petkov wrote:
>
> On Sun, Nov 23, 2014 at 06:22:56PM +0100, Oleg Nesterov wrote:
> > Could you identify somehow the line which matches
> > task_sched_runtime+0x99 ? Probably do_task_delta_exec()...
>
> See http://marc.info/?l=linux-kernel&m=141675498417759&w=2
>
> Chris triggers the same splat and reverting
>
> 6e998916dfe3 ("sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency")
>
> fixes the issue for him. I'm testing that same thing reverted too, first
> resume cycle looks good.

Yes, this probably confirms the theory, stop_class needs update_curr.

Oleg.

