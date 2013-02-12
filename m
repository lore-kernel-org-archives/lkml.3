Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab3BLRiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:38:19 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:34494 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3BLRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:38:17 -0500
Date: Tue, 12 Feb 2013 09:38:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] stop_machine: dequeue work before signal completion
Message-ID: <20130212173812.GG7348@htj.dyndns.org>
References: <CAJd=RBAJdTewGVs2CFoto6ybnxUOJKHSF57nZQT25uF7B-b+fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAJdTewGVs2CFoto6ybnxUOJKHSF57nZQT25uF7B-b+fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 01:26:11PM +0800, Hillf Danton wrote:
> When a CPU is finally put down in either CPU_UP_CANCELLED or
> CPU_POST_DEAD, cpu_stop_cpu_callback() signals immediate completion on
> all cpu_stop_works still queued on the dead CPU; unfortunately, this
> code is buggy in that it doesn't remove the canceled work items off
> the stopper->works leaving it corrupted, which will trigger BUG_ON()
> during CPU_UP_PREPARE if the CPU is brought back online.
> 
> This bug isn't easily triggered because CPU_DOWN has to race against
> cpu_stop calls and most, if not all, cpu stop users pin target CPUs.
> 
> Fix it by popping each work item off stopper->works.
> 
> Thanks Tejun for sharing commit message, again.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> Cc: stable@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Andrew, this one too.

Thank you!

-- 
tejun
