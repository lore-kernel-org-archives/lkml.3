Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab3DBBoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:44:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57992 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472Ab3DBBoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:44:12 -0400
Date: Mon, 1 Apr 2013 21:43:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 13/33] wait: add wait_event_hrtimeout()
Message-ID: <20130402014353.GB30122@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Zach Brown <zab@redhat.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
	Asai Thambi S P <asamymuthupa@micron.com>,
	Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
	Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-14-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-14-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:34AM -0700, Kent Overstreet wrote:
> Analagous to wait_event_timeout() and friends, this adds
> wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().
> 
> Note that unlike the versions that use regular timers, these don't return
> the amount of time remaining when they return - instead, they return 0 or
> -ETIME if they timed out.  because I was uncomfortable with the semantics
> of doing it the other way (that I could get it right, anyways).
> 
> If the timer expires, there's no real guarantee that expire_time -
> current_time would be <= 0 - due to timer slack certainly, and I'm not
> sure I want to know the implications of the different clock bases in
> hrtimers.
> 
> If the timer does expire and the code calculates that the time remaining
> is nonnegative, that could be even worse if the calling code then reuses
> that timeout.  Probably safer to just return 0 then, but I could imagine
> weird bugs or at least unintended behaviour arising from that too.
> 
> I came to the conclusion that if other users end up actually needing the
> amount of time remaining, the sanest thing to do would be to create a
> version that uses absolute timeouts instead of relative.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

