Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaBTXpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:45:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64558 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752832AbaBTXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:44:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [Update][PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI companions of SATA devices
Date: Fri, 21 Feb 2014 00:59:50 +0100
Message-ID: <4483557.ntKET9UxSY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140220142639.GD6897@htj.dyndns.org>
References: <3011875.q18rCmXyYX@vostro.rjw.lan> <5317534.79aoyQFAO7@vostro.rjw.lan> <20140220142639.GD6897@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 20, 2014 09:26:39 AM Tejun Heo wrote:
> On Thu, Feb 20, 2014 at 02:47:19AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Modify the SATA subsystem to add hotplug contexts to ACPI companions
> > of SATA devices and ports instead of registering special ACPI dock
> > operations using register_hotplug_dock_device().
> > 
> > That change will allow the entire code handling those special ACPI
> > dock operations to be dropped in the next commit.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > As noted by Aaron, the hotplug contexts are not freed during ATA device
> > unregistration, but that is not necessary, because the struct acpi_device
> > things they are attached to never go away.  However, they obviously should
> > not be created more than once per struct acpi_device, so I've modified the
> > patch to skip the creation of hotplug contexts for devices that already
> > have them.
> 
> Please feel free to route with the rest of acpi changes.

I will.

>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
