Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967292Ab3E3CMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:12:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38315 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859Ab3E3CMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <5422298.byNmKLLQxX@vostro.rjw.lan>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com>
	<CAE9FiQV8CZN+mQvZScr16y9R1y6Tyx7uQg_DbNwE5KkHdi5H1w@mail.gmail.com>
	<19316305.cljVYtP0Hv@vostro.rjw.lan>
	<5422298.byNmKLLQxX@vostro.rjw.lan>
Date: Wed, 29 May 2013 19:12:04 -0700
X-Google-Sender-Auth: sBl3oHAIE3V1zcotSFUyTdxHCig
Message-ID: <CAE9FiQWSKABKkvuHBeHzX4WuCuK+XGe_37idbzOQ6JbGSCCmbQ@mail.gmail.com>
Subject: Re: System slow down from udev
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 5:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, May 30, 2013 01:55:07 AM Rafael J. Wysocki wrote:
>> On Wednesday, May 29, 2013 03:49:38 PM Yinghai Lu wrote:
>> > On Wed, May 29, 2013 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > On Wednesday, May 29, 2013 01:13:46 PM Yinghai Lu wrote:
>> > >> On Wed, May 29, 2013 at 4:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > >> > On your systems the processor driver is built-in.  Any chance to build it as
>> > >> > a module and see if that helps?
>> > >>
>> > >> it CONFIG_ACPI_PROCESSOR it not set in the config
>> > >> the boot get to normal speed.
>> > >
>> > > Well, if it is not set at all, there won't be problems with it. :-)
>> > >
>> > > I've tested my linux-next branch on OpenSUSE 11.3 both with the processor
>> > > driver built in and modular and I'm not able to reproduce the issue you're
>> > > seeing.
>> > >
>> > > Moreover, I'm not sure if user space is involved here at all, because the
>> > > problem triggers for you when all of the relevant kernel code is non-modular.
>> > >
>> > > With the processor driver enabled, when the slowdown happens, are the systems
>> > > usable enough to get some debug info out of them?
>> >
>> > please check the bootchart data.
>> >
>> > looks like it take 200s if no acpi_processor ...
>> > otherwise will take 800s or more.
>>
>> Well, something's fishy for sure.
>>
>> To my eyes it looks like we're getting lots of notifications related to the
>> processor driver and that generates a lot of workqueue load.
>>
>> Can you please get /proc/interrupts from both cases and the output of
>> "find /sys/firmware/acpi/interrupts/ -print -exec cat {} \;"?
>>
>> Also please send the output of "ls -l /sys/devices/system/cpu/cpu*" with the
>> processor driver present.
>
> Well, this is kind of a blind shot, but I'm wondering if the appended patch
> makes any difference?

No difference. it's still slow.

>
>
> ---
>  drivers/acpi/processor_driver.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> Index: linux-pm/drivers/acpi/processor_driver.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/processor_driver.c
> +++ linux-pm/drivers/acpi/processor_driver.c
> @@ -87,9 +87,6 @@ static void acpi_processor_notify(acpi_h
>         struct acpi_processor *pr;
>         int saved;
>
> -       if (device->handle != handle)
> -               return;
> -
>         pr = acpi_driver_data(device);
>         if (!pr)
>                 return;
>
