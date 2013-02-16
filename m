Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3BPRSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:18:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3BPRSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:18:53 -0500
Date: Sat, 16 Feb 2013 18:17:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/5] coredump: use a freezable_schedule for the
	coredump_finish wait
Message-ID: <20130216171735.GG4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-3-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361008406-2307-3-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Mandeep Singh Baines wrote:
>
> @@ -483,7 +484,7 @@ static void exit_mm(struct task_struct * tsk)
>  			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>  			if (!self.task) /* see coredump_finish() */
>  				break;
> -			schedule();
> +			freezable_schedule();

I think this particular change is fine in any case, no matter what
else will we do.

Acked-by: Oleg Nesterov <oleg@redhat.com>

