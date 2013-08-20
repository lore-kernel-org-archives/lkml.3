Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3HTMOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:14:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51313 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3HTMOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:14:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] ACPI / PM: Hold acpi_scan_lock over system PM transitions
Date: Tue, 20 Aug 2013 14:24:42 +0200
Message-ID: <4492949.n2Wo36SnUY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820110833.GZ4898@intel.com>
References: <2852781.TfChGuuEkJ@vostro.rjw.lan> <20130820110833.GZ4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 02:08:33 PM Mika Westerberg wrote:
> On Tue, Aug 20, 2013 at 01:47:57AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Bad things happen if ACPI hotplug events are handled during system
> > PM transitions, especially if devices are removed as a result.
> > To prevent those bad things from happening, acquire acpi_scan_lock
> > when a transition is started and release it when that transition
> > is complete or has been aborted.
> > 
> > This fixes resume lockup on my test-bed Acer Aspire S5 that happens
> > when Thunderbolt devices are disconnected from the machine while
> > suspended.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> I tested this on Intel DZ77RE-75K and after the patch is applied the
> machine didn't hang anymore once resuming.
> 
> Feel free to add my tested-by.

I will, thanks!

