Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaKWRqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:46:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47803 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaKWRqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:46:08 -0500
Date: Sun, 23 Nov 2014 18:46:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>
Subject: Re: task_stat splat
Message-ID: <20141123174604.GA4054@pd.tnic>
References: <20141123111220.GA6436@pd.tnic>
 <20141123172256.GA9625@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141123172256.GA9625@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 06:22:56PM +0100, Oleg Nesterov wrote:
> Could you identify somehow the line which matches
> task_sched_runtime+0x99 ? Probably do_task_delta_exec()...

See http://marc.info/?l=linux-kernel&m=141675498417759&w=2

Chris triggers the same splat and reverting

6e998916dfe3 ("sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency")

fixes the issue for him. I'm testing that same thing reverted too, first
resume cycle looks good.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
