Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3ASNzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 08:55:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46799 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3ASNzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 08:55:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 18 (acpi)
Date: Sat, 19 Jan 2013 15:01:09 +0100
Message-ID: <1563609.uEd3dQW5Ul@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUVE3xFzdqrM6ZsJDQfZ8Qb6ptnQuhBiVOVY1SE3Fe8OBA@mail.gmail.com>
References: <20130118153707.0909fb9039e411acc1674c32@canb.auug.org.au> <4935167.QM3InZsTWy@vostro.rjw.lan> <CA+icZUVE3xFzdqrM6ZsJDQfZ8Qb6ptnQuhBiVOVY1SE3Fe8OBA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 02:50:17 PM Sedat Dilek wrote:
> On Sat, Jan 19, 2013 at 2:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, January 18, 2013 05:42:20 PM Randy Dunlap wrote:
> >> On 01/17/13 20:37, Stephen Rothwell wrote:
> >> > Hi all,
> >> >
> >> > Changes since 20130117:
> >> >
> >>
> >>
> >> on x86_64:
> >>
> >>   CC      drivers/acpi/device_pm.o
> >> drivers/acpi/device_pm.c:778:5: error: redefinition of 'acpi_dev_suspend_late'
> >> In file included from include/acpi/acpi_drivers.h:29:0,
> >>                  from drivers/acpi/device_pm.c:33:
> >> include/linux/acpi.h:526:19: note: previous definition of 'acpi_dev_suspend_late' was here
> >> drivers/acpi/device_pm.c:810:5: error: redefinition of 'acpi_dev_resume_early'
> >> In file included from include/acpi/acpi_drivers.h:29:0,
> >>                  from drivers/acpi/device_pm.c:33:
> >> include/linux/acpi.h:527:19: note: previous definition of 'acpi_dev_resume_early' was here
> >> drivers/acpi/device_pm.c:828:5: error: redefinition of 'acpi_subsys_prepare'
> >> In file included from include/acpi/acpi_drivers.h:29:0,
> >>                  from drivers/acpi/device_pm.c:33:
> >> include/linux/acpi.h:528:19: note: previous definition of 'acpi_subsys_prepare' was here
> >> drivers/acpi/device_pm.c:846:5: error: redefinition of 'acpi_subsys_suspend_late'
> >> In file included from include/acpi/acpi_drivers.h:29:0,
> >>                  from drivers/acpi/device_pm.c:33:
> >> include/linux/acpi.h:529:19: note: previous definition of 'acpi_subsys_suspend_late' was here
> >> drivers/acpi/device_pm.c:861:5: error: redefinition of 'acpi_subsys_resume_early'
> >> In file included from include/acpi/acpi_drivers.h:29:0,
> >>                  from drivers/acpi/device_pm.c:33:
> >> include/linux/acpi.h:530:19: note: previous definition of 'acpi_subsys_resume_early' was here
> >> make[3]: *** [drivers/acpi/device_pm.o] Error 1
> >>
> >>
> >>
> >>
> >> Full randconfig file is attached.
> >
> > Thanks, I'll take it for inclusion into the build testing framework.
> >
> > The appended patch fixes the problem for me.
> >
> > Thanks,
> > Rafael
> >
> >
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / PM: Fix build for unusual combination of Kconfig options
> >
> > CONFIG_PM_SLEEP may be set even if CONFIG_ACPI_SLEEP is unset,
> > although that is unusual.  For this reason, make the headers of
> > functions built for both CONFIG_ACPI and CONFIG_PM_SLEEP set
> > simultaneously depend on that combination of Kconfig options
> > instead of CONFIG_ACPI_SLEEP.
> >
> > This fixes a build problem reported by Randy Dunlap.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  include/linux/acpi.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-pm/include/linux/acpi.h
> > ===================================================================
> > --- linux-pm.orig/include/linux/acpi.h
> > +++ linux-pm/include/linux/acpi.h
> 
> Can you tell me how do you create such a patch with "Index:" line?
> 
> linux-pm.orig as a reference is not very meaninful :-).
> 
> If this is against Linux-Next (next-20130118) I would like to see:
> --- next-20130118.orig/path/to/file
> +++ next-20130118/path/to/file
> 
> I had used 'git format-patch' with '--subject-prefix="PATCH
> next-20130118"' option in such a case.
> Just as a hint by not telling you how you should do your job.
> 
> /me is still a Git n00b!

Well, I use quilt to generate patches. :-)

This particular one was generated with "quilt refresh --diffstat", I'm not
sure how to get the same result using git, sorry.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
