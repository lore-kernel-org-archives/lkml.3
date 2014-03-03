Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaCCX2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:28:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64922 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755308AbaCCX2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:28:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jon Ringle <jon@ringle.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Subject: Re: Ethernet controller not starting
Date: Tue, 04 Mar 2014 00:43:14 +0100
Message-ID: <3049227.1OEyu61877@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMwGMjwjyZkj3_bKUcx4GXNP764UaUG=d6V1us8GgMKj=HoXVw@mail.gmail.com>
References: <CAMwGMjwjyZkj3_bKUcx4GXNP764UaUG=d6V1us8GgMKj=HoXVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2014 02:41:01 PM Jon Ringle wrote:
> I'm working on porting an ARM board from linux-3.10 to linux-3.12 (now
> the latest LTS kernel).
> I found that Ethernet controller on the board no longer comes up on linux-3.12.
> I was able to bisect the issue I'm having to the following commit:
> 
> >   45f0a85c8258741d11bda25c0a5669c06267204a is the first bad commit
> >   commit 45f0a85c8258741d11bda25c0a5669c06267204a
> >   Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >   Date:   Mon Jun 3 21:49:52 2013 +0200
> >
> >       PM / Runtime: Rework the "runtime idle" helper routine
> >
> >       The "runtime idle" helper routine, rpm_idle(), currently ignores
> >       return values from .runtime_idle() callbacks executed by it.
> >       However, it turns out that many subsystems use
> >       pm_generic_runtime_idle() which checks the return value of the
> >       driver's callback and executes pm_runtime_suspend() for the device
> >       unless that value is not 0.  If that logic is moved to rpm_idle()
> >       instead, pm_generic_runtime_idle() can be dropped and its users
> >       will not need any .runtime_idle() callbacks any more.
> >
> >       Moreover, the PCI, SCSI, and SATA subsystems' .runtime_idle()
> >       routines, pci_pm_runtime_idle(), scsi_runtime_idle(), and
> >       ata_port_runtime_idle(), respectively, as well as a few drivers'
> >       ones may be simplified if rpm_idle() calls rpm_suspend() after 0 has
> >       been returned by the .runtime_idle() callback executed by it.
> >
> >       To reduce overall code bloat, make the changes described above.
> >
> >       Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >       Tested-by: Kevin Hilman <khilman@linaro.org>
> >       Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >       Acked-by: Kevin Hilman <khilman@linaro.org>
> >       Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> >       Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Can anyone offer any suggestions on what I should be looking for to
> fix this on my board?

Any pointers to the driver in question?

Rafael

