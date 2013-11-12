Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3KLXdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:33:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63762 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754386Ab3KLXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:33:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
Date: Wed, 13 Nov 2013 00:46:15 +0100
Message-ID: <12494461.XagJySeqkW@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CALAqxLXL_rE=1BanFyR=4iTLsSoZttAu72aXraQnWBRr9HxYvw@mail.gmail.com>
References: <1384192591-20916-1-git-send-email-amit.pundir@linaro.org> <7789635.0eeyCxz2tM@vostro.rjw.lan> <CALAqxLXL_rE=1BanFyR=4iTLsSoZttAu72aXraQnWBRr9HxYvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 12, 2013 11:24:05 AM John Stultz wrote:
> On Mon, Nov 11, 2013 at 1:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, November 11, 2013 11:26:31 PM Amit Pundir wrote:
> >> While looking into the problem, I found that ep_create_wakeup_source()
> >> reports ENOMEM if wakeup_source_register() returns NULL.
> >> ep_create_wakeup_source() assumes that NULL is only returned if we run
> >> into ENOMEM but NULL is also returned when CONFIG_PM_SLEEP is disabled.
> >
> > So the error value should not be ENOMEM.
> 
> Right, ENOMEM is clearly wrong. I think its just not clear what the
> right thing to do is.
> 
> 
> >> If CONFIG_PM_SLEEP is disabled, stripping the EPOLLWAKEUP flag seems to
> >> be a reasonable solution here, allowing the call to succeed, while
> >> dropping the wakeup logic.  While returning EINVAL might also be a good
> >> solution, stripping the flag seems to follow the established behavior,
> >> as is done when the process doesn't have sufficient capabilities to
> >> block suspend.
> >
> > Which is a different thing.
> 
> Well, in the case of the process not having sufficient capabilities,
> -EPERM seems like a reasonable return value.  But instead the wakeup
> flag is silently dropped.  That's why Amit is asking if dropping the
> wakeup flag is also the right approach for the !PM_SLEEP case instead
> of returning EINVAL.
> 
> Dropping the wakeup flag is the easier solution, since we don't have
> to then go through all the userspace code and have it handle the error
> and resubmit without the wakeup flag.  I suspect this was the same
> consideration for the decision in the insufficient capabilities case,
> but I don't really know.

Yes, it was.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
