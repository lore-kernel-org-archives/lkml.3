Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaGGTv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:51:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60276 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750809AbaGGTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:51:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Ruchi Kandoi <kandoiruchi@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ghackmann@google.com, toddpoynor@google.com,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v4] power: add an API to log wakeup reasons
Date: Mon, 07 Jul 2014 22:09:28 +0200
Message-ID: <1513900.gylJAouuZq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANcMJZAm+TfX5W_AMSECBTb8tAzts9_YtOjCXGhmy4SgPAjYqg@mail.gmail.com>
References: <1394730340-3607-1-git-send-email-kandoiruchi@google.com> <CANcMJZAm+TfX5W_AMSECBTb8tAzts9_YtOjCXGhmy4SgPAjYqg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2014 03:02:18 PM John Stultz wrote:
> On Thu, Mar 13, 2014 at 6:05 PM, Ruchi Kandoi <kandoiruchi@google.com> wrote:
> > For power management diagnostic purposes, it is often useful to know
> > what interrupts are frequently waking the system from low power
> > suspend mode, especially on battery-powered consumer electronics
> > devices that are expected to spend much of their time in low-power
> > suspend while not in active use.  For example, reduced battery life on
> > a mobile phone may be caused in part by frequent wakeups by broadcast
> > traffic on a busy wireless LAN even while the screen is off and the
> > phone not in active use.
> >
> > Add API log_wakeup_reason() exposes it to userspace via the sysfs path
> > /sys/kernel/wakeup_reasons/last_resume_reason. This API would be called
> > from the paltform specific, or from the driver for the interrupt controller,
> > when the system resumes because of an IRQ. It logs the reasons which caused
> > the system to wakeup from the low-power mode.
> >
> > This information can be collected by userspace as part of the accounting
> > kept on power consumption.
> 
> Rafael,
>    I realize its been awhile here, but seeing as discussion on this
> petered out somewhat ambiguously, I was curious if your thoughts on
> using wakeup_sources for this was considered a prereq for further
> discussion or if it was a softer thought experiment?

It really was softer at that time, but today that we have the "freeze"
sleep state where wakeup sources really are used for wakeup it would make
more sense to used them here too.

Rafael

