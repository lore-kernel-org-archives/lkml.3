Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3ASO2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 09:28:39 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41273 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3ASO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 09:28:38 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX5OsAQNDCzJz97Phfu=hxYV_0QHa6UwsBUJFcMeNBVnQ@mail.gmail.com>
References: <20130118153707.0909fb9039e411acc1674c32@canb.auug.org.au>
	<4935167.QM3InZsTWy@vostro.rjw.lan>
	<CA+icZUVE3xFzdqrM6ZsJDQfZ8Qb6ptnQuhBiVOVY1SE3Fe8OBA@mail.gmail.com>
	<1563609.uEd3dQW5Ul@vostro.rjw.lan>
	<CA+icZUX5OsAQNDCzJz97Phfu=hxYV_0QHa6UwsBUJFcMeNBVnQ@mail.gmail.com>
Date: Sat, 19 Jan 2013 15:28:37 +0100
Message-ID: <CA+icZUUE1NvR=CiwEpcsnijsVAJBZ4Ev8aXKWWTnj=4d-52mrQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 (acpi)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 3:22 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 19, 2013 at 3:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Saturday, January 19, 2013 02:50:17 PM Sedat Dilek wrote:
>>> On Sat, Jan 19, 2013 at 2:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > On Friday, January 18, 2013 05:42:20 PM Randy Dunlap wrote:
>>> >> On 01/17/13 20:37, Stephen Rothwell wrote:
>>> >> > Hi all,
>>> >> >
>>> >> > Changes since 20130117:
>>> >> >
>>> >>
>>> >>
>>> >> on x86_64:
>>> >>
>>> >>   CC      drivers/acpi/device_pm.o
>>> >> drivers/acpi/device_pm.c:778:5: error: redefinition of 'acpi_dev_suspend_late'
>>> >> In file included from include/acpi/acpi_drivers.h:29:0,
>>> >>                  from drivers/acpi/device_pm.c:33:
>>> >> include/linux/acpi.h:526:19: note: previous definition of 'acpi_dev_suspend_late' was here
>>> >> drivers/acpi/device_pm.c:810:5: error: redefinition of 'acpi_dev_resume_early'
>>> >> In file included from include/acpi/acpi_drivers.h:29:0,
>>> >>                  from drivers/acpi/device_pm.c:33:
>>> >> include/linux/acpi.h:527:19: note: previous definition of 'acpi_dev_resume_early' was here
>>> >> drivers/acpi/device_pm.c:828:5: error: redefinition of 'acpi_subsys_prepare'
>>> >> In file included from include/acpi/acpi_drivers.h:29:0,
>>> >>                  from drivers/acpi/device_pm.c:33:
>>> >> include/linux/acpi.h:528:19: note: previous definition of 'acpi_subsys_prepare' was here
>>> >> drivers/acpi/device_pm.c:846:5: error: redefinition of 'acpi_subsys_suspend_late'
>>> >> In file included from include/acpi/acpi_drivers.h:29:0,
>>> >>                  from drivers/acpi/device_pm.c:33:
>>> >> include/linux/acpi.h:529:19: note: previous definition of 'acpi_subsys_suspend_late' was here
>>> >> drivers/acpi/device_pm.c:861:5: error: redefinition of 'acpi_subsys_resume_early'
>>> >> In file included from include/acpi/acpi_drivers.h:29:0,
>>> >>                  from drivers/acpi/device_pm.c:33:
>>> >> include/linux/acpi.h:530:19: note: previous definition of 'acpi_subsys_resume_early' was here
>>> >> make[3]: *** [drivers/acpi/device_pm.o] Error 1
>>> >>
>>> >>
>>> >>
>>> >>
>>> >> Full randconfig file is attached.
>>> >
>>> > Thanks, I'll take it for inclusion into the build testing framework.
>>> >
>>> > The appended patch fixes the problem for me.
>>> >
>>> > Thanks,
>>> > Rafael
>>> >
>>> >
>>> > ---
>>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> > Subject: ACPI / PM: Fix build for unusual combination of Kconfig options
>>> >
>>> > CONFIG_PM_SLEEP may be set even if CONFIG_ACPI_SLEEP is unset,
>>> > although that is unusual.  For this reason, make the headers of
>>> > functions built for both CONFIG_ACPI and CONFIG_PM_SLEEP set
>>> > simultaneously depend on that combination of Kconfig options
>>> > instead of CONFIG_ACPI_SLEEP.
>>> >
>>> > This fixes a build problem reported by Randy Dunlap.
>>> >
>>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> > ---
>>> >  include/linux/acpi.h |    2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > Index: linux-pm/include/linux/acpi.h
>>> > ===================================================================
>>> > --- linux-pm.orig/include/linux/acpi.h
>>> > +++ linux-pm/include/linux/acpi.h
>>>
>>> Can you tell me how do you create such a patch with "Index:" line?
>>>
>>> linux-pm.orig as a reference is not very meaninful :-).
>>>
>>> If this is against Linux-Next (next-20130118) I would like to see:
>>> --- next-20130118.orig/path/to/file
>>> +++ next-20130118/path/to/file
>>>
>>> I had used 'git format-patch' with '--subject-prefix="PATCH
>>> next-20130118"' option in such a case.
>>> Just as a hint by not telling you how you should do your job.
>>>
>>> /me is still a Git n00b!
>>
>> Well, I use quilt to generate patches. :-)
>>
>> This particular one was generated with "quilt refresh --diffstat", I'm not
>> sure how to get the same result using git, sorry.
>>
>
> OK, I know I am a bad Git teacher, but from my p00r Git experiences...
>
> I required some of the below options of 'git format-patch' for the
> Freetz router project.
>
> [ Fight with "p0" VS. "p1" patch-format aka w/ or w/o prefix ]
>
> In general Freetz wants its patches in "p0" patch-format to fit its
> own "freetz_patch" tool.
> ( When I asked on the Git ML people did not know/like the terms "p0"
> and "p1" so it's in parenthesis. )
> This means patches should NOT contain "a/" and "b/" prefixes.
>
>        --no-prefix
>            Do not show any source or destination prefix.
>
> [ Add a "source" (override "a/") and a "destination" (override "b/") prefix ]
>
> You will like this one :-).
> In combination with the above I had to add
> "--src-prefix=linux-2.6.13.1.orig" and -dst-prefix="linux-2.6.13.1"
> for kernel-patches.
> YES, my router has a very ancient kernel-release :-(!
>
>        --src-prefix=<prefix>
>            Show the given source prefix instead of "a/".
>
>        --dst-prefix=<prefix>
>            Show the given destination prefix instead of "b/".
>
> [ Do NOT number patches in a series ]
>
> And last but not least, I personally do not like to see "[PATCH]
> 12/23" in a series of patches.

Just as note:
This is for the subject-line!
The numbering of patch is untouched (start: 0001 and end: 000x|00yy|0zzz).

- Sedat -

> Suppress this by using "--no-numbered" option.
> NOTE: For a single patch this option is useless :-)!
>
>        -N, --no-numbered
>            Name output in [PATCH] format.
>
> [ bonbon: cover-letter aka 0/x or 00/yy or 000/zzz (IMHO zzz is more a
> "love-letter" :-)) ]
>
>        --cover-letter
>            In addition to the patches, generate a cover letter file
> containing the shortlog and the overall diffstat. You can fill in a
> description in the file before sending it out.
>
> I like when people send a cover-letter where they put all the relevant
> informations for the ***complete*** patch-series.
> This is very helpful for people who want to review.
> So, you can reply comments to the cover-letter-email for a general discussions.
> Comments on the single patches you can do appropriately.
>
> A book recommendation for German speaking people (see [1])...
> ( IMPORTANT NOTE: I get no money for doing marketing for the book! )
>
> Hope this helps you :-)!
> But make your own Git experiences!
>
> - Sedat -
>
> [1] https://www.opensourcepress.de/git/
>
>> Thanks,
>> Rafael
>>
>>
>> --
>> I speak only for myself.
>> Rafael J. Wysocki, Intel Open Source Technology Center.
