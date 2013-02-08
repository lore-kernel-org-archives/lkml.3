Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947214Ab3BHWfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:35:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35474 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323Ab3BHWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:35:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] ACPI / scan: Remove useless #ifndef and simplify container driver
Date: Fri, 08 Feb 2013 23:41:21 +0100
Message-ID: <1435179.fU91E9qMVO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1891536.LKCrpu1upY@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1360342638.3869.59.camel@misato.fc.hp.com> <1891536.LKCrpu1upY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 08:59:44 PM Rafael J. Wysocki wrote:
> On Friday, February 08, 2013 09:57:18 AM Toshi Kani wrote:
> > On Fri, 2013-02-08 at 01:24 +0100, Rafael J. Wysocki wrote:
> > > On Monday, February 04, 2013 12:47:31 AM Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > The only useful thing that the ACPI container driver does is to
> > > > install system notify handlers for all container and module device
> > > > objects it finds in the namespace.  The driver structure,
> > > > acpi_container_driver, and the data structures created by its
> > > > .add() callback are in fact not used by the driver, so remove
> > > > them entirely.
> > > > 
> > > > It also makes a little sense to build that driver as a module,
> > > > so make it non-modular and add its initialization to the
> > > > namespace scanning code.
> > > > 
> > > > In addition to that, make the namespace walk callback used for
> > > > installing the notify handlers more straightforward.
> > > 
> > > As pointed out by Toshi Kani, the above changes would make acpi_eject_store()
> > > fail for containers and it is the only way to eject them currently, so patch
> > > [2/2] is an improved version of this (with Toshi's changes folded in).
> > > 
> > > Patch [1/2] is just a cleanup removing a useless #ifndef from acpi_eject_store().
> > 
> > Thanks for the update!  They look good.  For the series:
> > 
> > Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> > Tested-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > BTW, did you intentionally keep the struct acpi_container definition in
> > <acpi/container.h>?  I deleted that one in my patch.
> 
> No, I overlooked that part.  I'll apply that part of your patch as a separate
> patch on top of this one.

Actually, I prefer to remove container.h entirely.  I'll post a patch for that
shortly.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
