Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaCKIRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:17:40 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:46497 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaCKIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:17:37 -0400
Date: Tue, 11 Mar 2014 09:17:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/15] sched/prio: Add a macro named NICE_TO_RLIMIT in
 prio.h.
Message-ID: <20140311081730.GA4298@osiris>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
 <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031108-2966-0000-0000-00000A89AF5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 12:59:16PM +0800, Dongsheng Yang wrote:
> This patch add a macro named NICE_TO_RLIMIT in prio.h to
> convert nice value [19,-20] to rlimit style value [1,40].
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  include/linux/sched/prio.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
> index ac32258..8e78c47 100644
> --- a/include/linux/sched/prio.h
> +++ b/include/linux/sched/prio.h
> @@ -41,4 +41,9 @@
>  #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
>  #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
>  
> +/*
> + * Convert nice value [19,-20] to rlimit style value [1,40].
> + */
> +#define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)

Where is MAX_NICE defined? The s390 patch fails to compile.

Also you probably want at least extra braces around the 'nice' usage to
avoid subtle side effects. (or make NICE_TO.. a function, whatever).

