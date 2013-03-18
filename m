Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3CRMLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:11:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33188 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3CRMLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:11:23 -0400
Date: Mon, 18 Mar 2013 13:11:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <rric@kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/3] perf: Add persistent event facilities
Message-ID: <20130318121112.GA8879@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Robert Richter <rric@kernel.org>, Borislav Petkov <bp@suse.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <1363352789-17991-3-git-send-email-bp@alien8.de>
 <878v5ljcix.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878v5ljcix.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 18, 2013 at 06:13:58PM +0900, Namhyung Kim wrote:
> > -static void ring_buffer_put(struct ring_buffer *rb)
> > +void perf_ring_buffer_put(struct ring_buffer *rb)
> 
> Why did you rename this function?

Yeah, actually that's not needed.

However, the perf ring buffer function naming is kinda inconsistent:

ring_buffer_*
rb_*

Since we're keeping those internal to perf, they maybe should have the
same prefix, no?

I vote for "rb_" because it is shorter. :)

> > + err_event_file:
> > +	perf_event_release_kernel(event);
> 
> It needs to reset event to ERR_PTR(-ENOMEM) ?

Yeah, the error path in this function is kinda clumsy, I'll do some more
staring at how to make it simpler/better.

[ … ]

> > +	__list_del(desc->plist.prev, desc->plist.next);
> 
> Why not using list_del(&desc->plist) ?

Will do.

[ … ]

> > + err_event_file:
> > +	put_unused_fd(event_fd);
>
> Isn't it safe to have event_fd of -1 in case not found? Anyway, if
> it's returned to the user space directly, it's better having more
> meaningful error code IMHO.

Yeah, I rewrote that one in the meantime to use a helper and it is
cleaner now.

Thanks for the review!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
