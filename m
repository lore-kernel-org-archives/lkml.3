Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967242Ab3E2XqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:46:20 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54421 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040Ab3E2XqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:46:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System slow down from udev
Date: Thu, 30 May 2013 01:55:07 +0200
Message-ID: <19316305.cljVYtP0Hv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQV8CZN+mQvZScr16y9R1y6Tyx7uQg_DbNwE5KkHdi5H1w@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <2968280.mrRQeH7SYv@vostro.rjw.lan> <CAE9FiQV8CZN+mQvZScr16y9R1y6Tyx7uQg_DbNwE5KkHdi5H1w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 03:49:38 PM Yinghai Lu wrote:
> On Wed, May 29, 2013 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, May 29, 2013 01:13:46 PM Yinghai Lu wrote:
> >> On Wed, May 29, 2013 at 4:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On your systems the processor driver is built-in.  Any chance to build it as
> >> > a module and see if that helps?
> >>
> >> it CONFIG_ACPI_PROCESSOR it not set in the config
> >> the boot get to normal speed.
> >
> > Well, if it is not set at all, there won't be problems with it. :-)
> >
> > I've tested my linux-next branch on OpenSUSE 11.3 both with the processor
> > driver built in and modular and I'm not able to reproduce the issue you're
> > seeing.
> >
> > Moreover, I'm not sure if user space is involved here at all, because the
> > problem triggers for you when all of the relevant kernel code is non-modular.
> >
> > With the processor driver enabled, when the slowdown happens, are the systems
> > usable enough to get some debug info out of them?
> 
> please check the bootchart data.
> 
> looks like it take 200s if no acpi_processor ...
> otherwise will take 800s or more.

Well, something's fishy for sure.

To my eyes it looks like we're getting lots of notifications related to the
processor driver and that generates a lot of workqueue load.

Can you please get /proc/interrupts from both cases and the output of
"find /sys/firmware/acpi/interrupts/ -print -exec cat {} \;"?

Also please send the output of "ls -l /sys/devices/system/cpu/cpu*" with the
processor driver present.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
