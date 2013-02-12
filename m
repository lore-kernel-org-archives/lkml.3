Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab3BLRho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:37:44 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41699 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3BLRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:37:43 -0500
Date: Tue, 12 Feb 2013 09:37:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] stop_machine: check work->done while handling
 enqueued works
Message-ID: <20130212173737.GF7348@htj.dyndns.org>
References: <CAJd=RBCi0gRGf2ronNyGDBeNsBJkEZ6aTe29gVnTUD2qh6Bnog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCi0gRGf2ronNyGDBeNsBJkEZ6aTe29gVnTUD2qh6Bnog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 01:22:43PM +0800, Hillf Danton wrote:
> In cpu_stopper_thread(), @work->done may be NULL if the cpu stop work
> is queued from stop_one_cpu_nowait(); however, cpu_stopper_thread()
> updates @done->ret without checking whether @done exists or not when
> the work function fails.
> 
> While this can lead to oops, the only current user of
> stop_one_cpu_nowait() - active_load_balance_cpu_stop() - always
> returns 0 and thus there's no in-kernel user which triggers this bug.
> 
> Fix it by checking whether @done exists before updating @done->ret.
> 
> Thanks Tejun for sharing commit message.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Andrew, can you please take this?

Thanks.

-- 
tejun
