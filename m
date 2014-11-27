Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaK0Qbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:31:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61038 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750821AbaK0Qba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:31:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in core code
Date: Thu, 27 Nov 2014 17:52:46 +0100
Message-ID: <2907778.ZNoNjGGGYl@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFox8bXyFT0861Tc8YY5HLyq5uPVGkfN0G4fXDKqQynkYQ@mail.gmail.com>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <CAPDyKFox8bXyFT0861Tc8YY5HLyq5uPVGkfN0G4fXDKqQynkYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 09:57:33 AM Ulf Hansson wrote:
> On 27 November 2014 at 01:37, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > Hi,
> >
> > After commit b2b49ccbdd54 "PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected" (currently in Linux next) CONFIG_PM_RUNTIME is set whenever
> > CONFIG_PM is set, so CONFIG_PM can be used in #ifdefs instead of
> > CONFIG_PM_RUNTIME which simplifies things in quite a few cases.
> >
> > For this reason, the following patches modify some core code to use
> > CONFIG_PM instead of CONFIG_PM_RUNTIME.
> >
> > [1/4] Drop a macro which is redundant after the above commit.
> > [2/4] Use PM instead of PM_RUNTIME in the core device PM code.
> > [3/4] Use PM instead of PM_RUNTIME in the ACPI core.
> > [4/4] Use PM instead of PM_RUNTIME in the PCI core.
> >
> > They build for me for all of the relevant combinations of options (on x86),
> > but more testing (on the other architectures) would be welcome.
> 
> I really like the looks of this patchset!
> 
> Noticed that you have applied it for your bleeding edge branch, I
> suppose that means you will get some "free" testing in linux-next?
> 
> Anyway, I have tested it for ux500 (including the genpd support for
> it, available in linux-next). It works nicely!
> 
> I have also tested the two Kconfig options; CONFIG_PM_SLEEP (which
> selects CONFIG_PM_RUNTIME) and for CONFIG_PM_RUNTIME (with
> CONFIG_PM_SLEEP unset).
> 
> That brings me to a raise a question; why do we need to keep these two
> configurations options? Couldn't we also have CONFIG_PM_RUNTIME to
> select CONFIG_PM_SLEEP, that will further simplify things?

My plan is different.  I'm going to eliminate PM_RUNTIME from the code
and then replace it with PM as a selectable option.  Then, PM_SLEEP will
select PM (directly) and PM_RUNTIME can be entirely dropped.

So in the end we'll have one Kconfig option less, which is a win IMO.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
