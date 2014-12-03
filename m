Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaLCWaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:30:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64295 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751124AbaLCWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:30:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/4] PM: Drop the SET_PM_RUNTIME_PM_OPS() macro
Date: Wed, 03 Dec 2014 23:51:44 +0100
Message-ID: <2647870.gu06V1GGvo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFoZmCYYNAGfNzwwEj=jk9wrfCKoxqQ4p=KStADSK1suCg@mail.gmail.com>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <3484329.phAPviVnbd@vostro.rjw.lan> <CAPDyKFoZmCYYNAGfNzwwEj=jk9wrfCKoxqQ4p=KStADSK1suCg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2014 03:15:49 PM Ulf Hansson wrote:
> On 27 November 2014 at 01:38, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The SET_PM_RUNTIME_PM_OPS() and SET_RUNTIME_PM_OPS() macros are
> > identical except that one of them is not empty for CONFIG_PM set,
> > while the other one is not empty for CONFIG_PM_RUNTIME set,
> > respectively.
> >
> > However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> > PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so one
> > of these macros is now redundant.
> >
> > For this reason, drop SET_PM_RUNTIME_PM_OPS() and replace it with
> > SET_RUNTIME_PM_OPS() everywhere.
> 
> Hi Rafael,
> 
> Apparently, I have queued an mmc patch in my mmc tree, which means one
> mmc driver starts using the SET_PM_RUNTIME_PM_OPS macro. It should
> cause a build error in linux-next with @subject patch.
> 
> I have shared that patch through an immutable branch, I have also
> checked potential conflicts and it shouldn't be any problems to pull
> that in to your tree. Then you can fix $subject patch by also
> converting the mmc driver to use SET_RUNTIME_PM_OPS macro.
> 
> The branch is available at:
> git://git.linaro.org/people/ulf.hansson/mmc.git mmc_for_linux_pm

Thanks for letting me know!

What about adding the following line to the $subject patch instead:

#define SET_PM_RUNTIME_PM_OPS	SET_RUNTIME_PM_OPS

and fixing things up when all has been merged?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
