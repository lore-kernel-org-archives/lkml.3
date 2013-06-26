Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3FZVZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:25:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52452 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3FZVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:25:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] power: Add warning message about incorrect system date and time after resume when pm_trace is enabled
Date: Wed, 26 Jun 2013 23:34:44 +0200
Message-ID: <1663571.CBNvhg7ZvS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61731812@sisaex02sj>
References: <1372116318-10824-1-git-send-email-shuah.kh@samsung.com> <2689226.oQ0T3XLPmT@vostro.rjw.lan> <B8EFE96D1287C24090BAD9D858E15E61731812@sisaex02sj>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 26, 2013 09:12:51 PM Shuah Khan wrote:
> On 06/25/2013 05:01 PM, Rafael J. Wysocki wrote:
> > On Monday, June 24, 2013 05:25:18 PM Shuah Khan wrote:
> >> pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
> >> Reason for this is that the RTC is the only reliably available piece of
> >> hardware during resume operations where a value can be set that will
> >> survive a reboot.
> >>
> >> Consequence is that after a resume (even if it is successful) your system
> >> clock will have a value corresponding to the magic number instead of the
> >> correct date/time! It is therefore advisable to use a program like ntp-date
> >> or rdate to reset the correct date/time from an external time source when
> >> using this trace option.
> >>
> >> There is no run-time message to warn users of the consequences of enabling
> >> pm_trace. Adding a warning message to pm_trace_store() will serve as a
> >> reminder to users to set the system date and time after resume.
> >>
> >> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> >> ---
> >>   kernel/power/main.c |    2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/kernel/power/main.c b/kernel/power/main.c
> >> index d77663b..fd744d1 100644
> >> --- a/kernel/power/main.c
> >> +++ b/kernel/power/main.c
> >> @@ -528,6 +528,8 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
> >>
> >>   	if (sscanf(buf, "%d", &val) == 1) {
> >>   		pm_trace_enabled = !!val;
> >> +		pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n");
> >> +		pr_cont("PM: Remember to set correct time after resume\n");
> >
> > You can do it like this:
> >
> > +	pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n"
> > +		  "PM: Remember to set correct time after resume\n");
> >
> > No need to use pr_cont(). :-)
> 
> :) Yeah.
> 
> >
> > And I'd say "during" instead of "after" in the first sentence.
> >
> > I'd also say something like "Correct system time has to be restored manually after resume."
> > instead of the second one.
> >
> 
> Will do. I think I should add a check and print this warning when 
> pm_trace is enabled and not when it is disabled. The way this patch is 
> done, it prints this warning for enable and disable. For both:
> 
> echo 1 > pm_trace and echo 0 > pm_trace.
> 
> Any thoughts?

Yeah, please only make it be printed when pm_trace is being enabled.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
