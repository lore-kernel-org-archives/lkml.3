Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774Ab3B0S5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740Ab3B0S5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:57:08 -0500
Date: Wed, 27 Feb 2013 19:55:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] freezer: do not send a fake signal to a
	PF_DUMPCORE thread
Message-ID: <20130227185530.GA7833@redhat.com>
References: <20130224173144.GA32179@redhat.com> <20130224173206.GA32206@redhat.com> <20130224183656.GA8903@redhat.com> <CACBanvoOdfZr1x5kU1+fmtex1Cuoas_LwBKwZ_giiLE511E-jg@mail.gmail.com> <CACBanvr5vbkH1J+waRHMBq8hRuKqJtF0sD0+95v6Qmnd=3Zd_w@mail.gmail.com> <20130227180844.GA6015@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227180844.GA6015@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Oleg Nesterov wrote:
>
> On 02/26, Mandeep Singh Baines wrote:
> >
> > You'd rather have reliable suspend than coredumps that aren't
> > truncated so you need to set TIF_SIGPENDING to break waits in the
> > dump_write path.
>
> Oh, I agree. In this case the necessary changes look simple.

Really. What if we simply add

	if (signal_pending())
		// SIGKILL or freezing()
		return -EINTR;

into dump_write() and change 3/3 to use wait_event_interruptible?

At least for the start. This is at least consistent, we do not
prevent suspend but the coredumping can be truncated (with the
current code "truncated" can happen anyway).

Then we can try to make it freezable or simply forget about this
imho minor problem.

What do you think?

Oleg.

