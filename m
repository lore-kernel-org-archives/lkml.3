Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaCaNEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:04:21 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35375 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:04:19 -0400
Date: Mon, 31 Mar 2014 15:04:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v2]
Message-ID: <20140331130417.GG22728@two.firstfloor.org>
References: <1396270321-20007-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396270321-20007-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  		do_initcall_level(level);
> +
> +	list_for_each_safe(tmp, next, &blacklisted_initcalls) {
> +		entry = list_entry(tmp, struct blacklist_entry, next);
> +		free_bootmem(entry->buf, strlen(entry->buf));
> +		free_bootmem(entry, sizeof(*entry));

Does that really work? At this point the bootmem allocator should
be already finished, so no memory will be freed.

For this case it's probably ok to leak it.

Alternatively you could use static arrays and storing pointer/len.

-Andi
