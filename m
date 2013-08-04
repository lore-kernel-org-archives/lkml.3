Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3HDNxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 09:53:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55101 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3HDNxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 09:53:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already bound correctly
Date: Sun, 04 Aug 2013 16:03:27 +0200
Message-ID: <1981183.omDzKl0aqK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375576322.10300.146.camel@misato.fc.hp.com>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan> <3596381.TNBAQz9C67@vostro.rjw.lan> <1375576322.10300.146.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 06:32:02 PM Toshi Kani wrote:
> On Sat, 2013-08-03 at 02:47 +0200, Rafael J. Wysocki wrote:
> > On Friday, August 02, 2013 04:38:38 PM Toshi Kani wrote:
> > > On Fri, 2013-08-02 at 00:33 +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Modify acpi_bind_one() so that it doesn't fail if the device
> > > > represented by its first argument has already been bound to the
> > > > given ACPI handle (second argument), because that is not a good
> > > > enough reason for returning an error code.
> > > 
> > > While it seems reasonable to allow such case, I do not think we will hit
> > > this case under the normal scenarios.  So, I do not think we need to
> > > make this change now unless it actually solves Yasuaki's issue (which I
> > > am guessing not).
> > 
> > In theory it should be possible to call acpi_bind_one() twice in a row
> > for the same dev and the same handle without failure, that simply is
> > logical.  The patch may not fix any problems visible now, but returning an
> > error code in such a case is simply incorrect.
> 
> We changed acpi_bus_device_attach() to not call the handler or driver
> again if it is already bound.  So, I was under impression that we
> prevent from attaching a same device twice.  But I may be missing
> something...

acpi_bind_one() may be called in code paths that don't start from
acpi_bus_device_attach(), like acpi_platform_notify(), where the result
depends on how .find_device() is implemented by the the given bus type,
for example.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
