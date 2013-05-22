Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3EVJHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:07:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55245
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab3EVJHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:07:02 -0400
Date: Wed, 22 May 2013 11:06:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org,
        mingo@redhat.com, Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
Message-ID: <20130522090643.GB18810@twins.programming.kicks-ass.net>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
 <1354024039.6276.72.camel@gandalf.local.home>
 <CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
 <CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com>
 <CAKohpo=0r=HY5w-XqnXv42eSJcH08C47J+TqWn7vY1aNBhGT_A@mail.gmail.com>
 <CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
 <alpine.LFD.2.02.1305131223470.2863@ionos>
 <CAKohpokfKPQ3EhMf3WB8koXuH2rF6QoejwNOTw08X+XfnVhpEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokfKPQ3EhMf3WB8koXuH2rF6QoejwNOTw08X+XfnVhpEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:04:16PM +0530, Viresh Kumar wrote:

> So, this is the clean draft for the idea I had.. (Naming is poor for
> now):
> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 8c5a197..ad00ebe 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -20,6 +20,7 @@ struct timer_list {
> 
>         void (*function)(unsigned long);
>         unsigned long data;
> +       int wait_for_migration_to_complete;

If you play games with the alignment constraints of struct tvec_base you
can get extra low bits to play with for TIMER_FLAG_MASK. See struct
pool_workqueue for similar games.

That would avoid the struct bloat and I suppose make tglx happy :-)
