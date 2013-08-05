Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3HEWg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:36:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57153 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3HEWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:36:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already bound correctly
Date: Tue, 06 Aug 2013 00:47:11 +0200
Message-ID: <14340982.ePfLp2GYsD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375741219.10300.172.camel@misato.fc.hp.com>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan> <1981183.omDzKl0aqK@vostro.rjw.lan> <1375741219.10300.172.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 05, 2013 04:20:19 PM Toshi Kani wrote:
> On Sun, 2013-08-04 at 16:03 +0200, Rafael J. Wysocki wrote:
> > On Saturday, August 03, 2013 06:32:02 PM Toshi Kani wrote:
> > > On Sat, 2013-08-03 at 02:47 +0200, Rafael J. Wysocki wrote:
> > > > On Friday, August 02, 2013 04:38:38 PM Toshi Kani wrote:
> > > > > On Fri, 2013-08-02 at 00:33 +0200, Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > 
> > > > > > Modify acpi_bind_one() so that it doesn't fail if the device
> > > > > > represented by its first argument has already been bound to the
> > > > > > given ACPI handle (second argument), because that is not a good
> > > > > > enough reason for returning an error code.
> > > > > 
> > > > > While it seems reasonable to allow such case, I do not think we will hit
> > > > > this case under the normal scenarios.  So, I do not think we need to
> > > > > make this change now unless it actually solves Yasuaki's issue (which I
> > > > > am guessing not).
> > > > 
> > > > In theory it should be possible to call acpi_bind_one() twice in a row
> > > > for the same dev and the same handle without failure, that simply is
> > > > logical.  The patch may not fix any problems visible now, but returning an
> > > > error code in such a case is simply incorrect.
> > > 
> > > We changed acpi_bus_device_attach() to not call the handler or driver
> > > again if it is already bound.  So, I was under impression that we
> > > prevent from attaching a same device twice.  But I may be missing
> > > something...
> > 
> > acpi_bind_one() may be called in code paths that don't start from
> > acpi_bus_device_attach(), like acpi_platform_notify(), where the result
> > depends on how .find_device() is implemented by the the given bus type,
> > for example.
> 
> acpi_bind_one() always returns with 0 when it sets a handle to the
> device.  So, acpi_platform_notify() should not call .find_device() in
> this case.  acpi_bus_check_add() is also protected from adding a same
> device twice.  But I see your point that the callers of acpi_bind_one()
> could be changed / implementation dependent.  So, I agree that it would
> be prudent to have this change. 
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

I wonder what you think about this patch:

https://patchwork.kernel.org/patch/2838675/

Rafael

