Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3JYOJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:09:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51548 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752480Ab3JYOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:09:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during shutdown
Date: Fri, 25 Oct 2013 16:21:31 +0200
Message-ID: <1396106.vGULxZgqeb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=QV831nP1WcdrWRCB7vkAtKPiSvSujbeE3usM+LCZpTg@mail.gmail.com>
References: <525BD08C.2080101@t-online.de> <1529148.xq0P7G6L83@vostro.rjw.lan> <CAKohpo=QV831nP1WcdrWRCB7vkAtKPiSvSujbeE3usM+LCZpTg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 25, 2013 07:19:57 PM Viresh Kumar wrote:
> On 25 October 2013 16:40, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > ---
> >  drivers/cpufreq/acpi-cpufreq.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > Index: linux-pm/drivers/cpufreq/acpi-cpufreq.c
> > ===================================================================
> > --- linux-pm.orig/drivers/cpufreq/acpi-cpufreq.c
> > +++ linux-pm/drivers/cpufreq/acpi-cpufreq.c
> > @@ -986,12 +986,12 @@ static int __init acpi_cpufreq_init(void
> >  {
> >         int ret;
> >
> > +       if (acpi_disabled)
> > +               return -ENODEV;
> > +
> >         /* don't keep reloading if cpufreq_driver exists */
> >         if (cpufreq_get_current_driver())
> > -               return 0;
> > -
> > -       if (acpi_disabled)
> > -               return 0;
> > +               return -EEXIST;
> >
> >         pr_debug("acpi_cpufreq_init\n");
> 
> Even better,
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

It doesn't lead to any unpleasant side effects on my laptop, so I'm adding it
to my queue of fixes for 3.12-rc7.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
