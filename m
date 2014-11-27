Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaK0VOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:14:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55097 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750966AbaK0VOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:14:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in core code
Date: Thu, 27 Nov 2014 22:35:15 +0100
Message-ID: <1803282.Wzz7IausxS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1411271216470.8104-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1411271216470.8104-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 12:18:23 PM Alan Stern wrote:
> On Thu, 27 Nov 2014, Geert Uytterhoeven wrote:
> 
> > Hi Rafael,
> > 
> > On Thu, Nov 27, 2014 at 5:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >> I have also tested the two Kconfig options; CONFIG_PM_SLEEP (which
> > >> selects CONFIG_PM_RUNTIME) and for CONFIG_PM_RUNTIME (with
> > >> CONFIG_PM_SLEEP unset).
> > >>
> > >> That brings me to a raise a question; why do we need to keep these two
> > >> configurations options? Couldn't we also have CONFIG_PM_RUNTIME to
> > >> select CONFIG_PM_SLEEP, that will further simplify things?
> > >
> > > My plan is different.  I'm going to eliminate PM_RUNTIME from the code
> > > and then replace it with PM as a selectable option.  Then, PM_SLEEP will
> > > select PM (directly) and PM_RUNTIME can be entirely dropped.
> > 
> > What's your rationale for keeping PM_SLEEP, and not consolidating both
> > PM_RUNTIME and PM_SLEEP into PM? I.e. what am I missing, still
> > considering myself a PM newbie?
> > 
> > > So in the end we'll have one Kconfig option less, which is a win IMO.
> > 
> > Having two less may be a bigger win ;-)
> 
> I imagine that Rafael would like to continue supporting platforms that 
> want to have runtime power management but not suspend or hibernation.  
> A number of embedded systems might fall into this category.

Right.

That said whether or not it is ever useful to set PM_RUNTIME alone is a good
question.  In my opinion it is useful today, at least on some platforms that
don't really support system suspend or hibernation in any form.  However, it
may not be the case any more when suspend-to-idle becomes mature enough,
because that should just work for any platform without any kind of special
support.  We're still missing some timekeeping bits there, but once that
gap has been covered, we may just eliminate PM_SLEEP as well if there's a
broad consensus on that.

Rafael

