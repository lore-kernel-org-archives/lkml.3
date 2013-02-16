Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3BPRH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3BPRHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:07:25 -0500
Date: Sat, 16 Feb 2013 18:06:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/5] lockdep: check that no locks held at freeze time
Message-ID: <20130216170605.GC4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361008406-2307-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, this is almost cosmetics, and I am not maintaner, but...

On 02/16, Mandeep Singh Baines wrote:
>
>  static inline bool try_to_freeze(void)
>  {
> +	if (current->flags & PF_NOFREEZE)
> +		return false;
> +	debug_check_no_locks_held(current, "lock held while trying to freeze");

I think this should be

	if (!(current->flags & PF_NOFREEZE))
		debug_check_no_locks_held(...);

without "return". This way we avoid the unnecessary PF_NOFREEZE check
if !CONFIG_LOCKDEP. And perhaps more importantly, this way it is clear
that we check PF_NOFREEZE for debugging only and do not change the code
behaviour.

But I leave this to Rafael/Tejun.

And again, unless I missed something, this makes 1/5 unnecessary.

Oleg.

