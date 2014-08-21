Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaHUQRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:17:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64573 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750858AbaHUQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:17:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Thu, 21 Aug 2014 18:36:26 +0200
Message-ID: <2344364.bO1d4HtJcY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408622934.3315.8.camel@rzhang1-toshiba>
References: <5487060.QsgluucUH4@vostro.rjw.lan> <1408622934.3315.8.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 08:08:54 PM Zhang Rui wrote:
> Hi, Rafael,
> 
> On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > We generally don't allow ACPI drivers to bind to ACPI device objects
> > that companion "physical" device objects are created for to avoid
> > situations in which two different drivers may attempt to handle one
> > device at the same time.
> 
> Yes, and I think we should not break this rule.

No, we broke the way the code worked previously.  We need to restore it first
and *then* try to fix it up, not the other way around.

> >   Recent ACPI device enumeration rework
> > extended that approach to ACPI PNP devices by starting to use a scan
> > handler for enumerating them.  However, we previously allowed ACPI
> > drivers to bind to ACPI device objects with existing PNP device
> > companions and changing that led to functional regressions on some
> > systems.
> > 
> Question: except the PNP0C01/PNP0C02 case, if we have an device have two
> ids that matches two different drivers, should we allow both drivers
> probe successfully?

No, we shouldn't, but in the cases in question we have only one driver (an
ACPI one).

> I think the answer is no.
> In the PNP0C01/PNP0C02 case, I think we can fix the issue by the
> following patch instead.

The right answer to me is to get rid of ACPI drviers entirely.

The thing below adds complexity to the resources management which I'm not
sure is necessary.

In any case, please let's do that on top of the $subject patch not
instead of it, because there are more cases we need to cover.  And we
need a fix for -stable.

Rafael

