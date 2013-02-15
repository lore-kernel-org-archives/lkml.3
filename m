Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960Ab3BOPqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935938Ab3BOPqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:46:06 -0500
Date: Fri, 15 Feb 2013 16:44:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/5] lockdep: check that no locks held at freeze time
Message-ID: <20130215154449.GD30829@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org> <1360885096-21207-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360885096-21207-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Mandeep Singh Baines wrote:
>
> We shouldn't try_to_freeze if locks are held. Verified that
> I get no lockdep warnings after applying this patch and
> "vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".

Ah. Now I understand why you did 1/5. Beacuse you call
debug_check_no_locks_held() right at the start of try_to_freeze(),
even if the caller can't be frozen.

>  static inline bool try_to_freeze(void)
>  {
> +	debug_check_no_locks_held(current);
>  	might_sleep();
>  	if (likely(!freezing(current)))
>  		return false;

Up to maintainers, but perhaps you should check !PF_NOFREEZE at least?

Oleg.

