Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaK0RS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:18:26 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57026 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750927AbaK0RSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:18:24 -0500
Date: Thu, 27 Nov 2014 12:18:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in
 core code
In-Reply-To: <CAMuHMdVD7+GqgjhXEHYsema5uLPG4A4HANAKyGO2DSTnoskezA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411271216470.8104-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Geert Uytterhoeven wrote:

> Hi Rafael,
> 
> On Thu, Nov 27, 2014 at 5:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> I have also tested the two Kconfig options; CONFIG_PM_SLEEP (which
> >> selects CONFIG_PM_RUNTIME) and for CONFIG_PM_RUNTIME (with
> >> CONFIG_PM_SLEEP unset).
> >>
> >> That brings me to a raise a question; why do we need to keep these two
> >> configurations options? Couldn't we also have CONFIG_PM_RUNTIME to
> >> select CONFIG_PM_SLEEP, that will further simplify things?
> >
> > My plan is different.  I'm going to eliminate PM_RUNTIME from the code
> > and then replace it with PM as a selectable option.  Then, PM_SLEEP will
> > select PM (directly) and PM_RUNTIME can be entirely dropped.
> 
> What's your rationale for keeping PM_SLEEP, and not consolidating both
> PM_RUNTIME and PM_SLEEP into PM? I.e. what am I missing, still
> considering myself a PM newbie?
> 
> > So in the end we'll have one Kconfig option less, which is a win IMO.
> 
> Having two less may be a bigger win ;-)

I imagine that Rafael would like to continue supporting platforms that 
want to have runtime power management but not suspend or hibernation.  
A number of embedded systems might fall into this category.

Alan Stern

