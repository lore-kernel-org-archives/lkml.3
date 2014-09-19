Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbaISTer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:34:47 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45708 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbaISTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com>
Date: Fri, 19 Sep 2014 21:34:43 +0200
Message-ID: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] sched: Silence nested-externs warnings
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-sparse@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 5:29 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
>
> Use diagnostic control macros to ignore nested-externs warnings
> in this case.
>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  include/linux/sched.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5c2c885..ed52c76 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -832,7 +832,9 @@ static inline int sched_info_on(void)
>  #ifdef CONFIG_SCHEDSTATS
>         return 1;
>  #elif defined(CONFIG_TASK_DELAY_ACCT)
> +       DIAG_PUSH DIAG_IGNORE(nested-externs)
>         extern int delayacct_on;
> +       DIAG_POP

This ridiculous, please try to move this extern into the appropriate header file
instead of surrounding it with these macros.

-- 
Thanks,
//richard
