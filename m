Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3E1MVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:21:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53249 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770Ab3E1MVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:21:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster governor - tests results
Date: Tue, 28 May 2013 14:30:23 +0200
Message-ID: <2272781.tC3OqoQmKI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=6Tk3NmcJw_fqnePu_skHKNB0rFBOUzEsCDyeLqxg4xA@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com> <20130528084035.13afa583@amdc308.digital.local> <CAKohpo=6Tk3NmcJw_fqnePu_skHKNB0rFBOUzEsCDyeLqxg4xA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 28, 2013 03:14:26 PM Viresh Kumar wrote:
> On 28 May 2013 12:10, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote: <manually added by viresh>
> >> On Monday, May 27, 2013 06:54:49 PM Viresh Kumar wrote:
> >> > On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> I was talking about /sys/devices/system/cpu/cpufreq/boost that
> >> appears to have been added by commit 615b730 (acpi-cpufreq: Add
> >> support for disabling dynamic overclocking).
> >>
> >> That's in acpi-cpufreq, but since that setting seems to be generally
> >> useful, it may be a good idea to move it to the core somehow.
> 
> Problem is in breaking existing cpufreq userspace for this driver.
> Is this allowed?
> 
> > I think that Viresh wanted to add "boost" option to
> > /sys/devices/system/cpu/cpuX/cpufreq/ to be able to control boost
> > at separate cores (policies).
> >
> > The localization, which you have proposed:
> > /sys/devices/system/cpu/cpufreq/boost
> >
> > implies, that boost is a global feature (enabled for all cores and for
> > all available policies).
> >
> > Which approach shall be used then?
> 
> We can use: get_governor_parent_kobj() to get the best location
> for boost. But I had some other issues in mind:
> - boost is governor dependent.. i.e. It is only required for ondemand
> governor (And LAB if it makes it to mainline :) ).. Other governors
> doesn't need it. So, it would be better to add it in governor's directory.

I'm not sure about that.  On x86 boost will be used with all governors if
enabled (as currently defined in acpi-cpufreq).

Also it looks like this depends on the driver too, because if the driver
doesn't have "turbo" frequencies, the governor won't be able use "turbo"
anyway.

> - This will break existing users of acpi-cpufreq driver.
> 
> @Rafael: Please suggest what to do here.

So first, it would make sense to use a per-driver "boost" attribute indicating
whether or not the given driver should present any "turbo" frequencies to the
governor.  That'd work along the lines of the acpi-cpufreq "boost", but I don't
think that the global_boost attribute should be created by the driver (it'd be
better if the driver provided methods to the core for handling that).

Second, I'm not sure if an additional knob for the governor is necessary.  It
may just use the turbo frequencies if available (and if the governor cannot use
them, it simply won't use them).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
