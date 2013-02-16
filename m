Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3BPRNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:13:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3BPRNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:13:46 -0500
Date: Sat, 16 Feb 2013 18:12:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/5] freezer: clear fake signal on exit from
	__refrigerator
Message-ID: <20130216171228.GF4910@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-4-git-send-email-msb@chromium.org> <20130216170644.GD4910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216170644.GD4910@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention...

On 02/16, Oleg Nesterov wrote:
> On 02/16, Mandeep Singh Baines wrote:
> >
> > --- a/kernel/freezer.c
> > +++ b/kernel/freezer.c
> > @@ -81,6 +81,9 @@ bool __refrigerator(bool check_kthr_stop)
> >  	 */
> >  	set_current_state(save);
> >
> > +	/* Clear fake signal from freeze_task(). */
> > +	recalc_sigpending();
>
> NACK. We can't do this lockless.
>
> And I am not sure we should reinstantiate it here.

And note that with the fix I propose in reply to 5/5 this change is
not needed.

Oleg.

