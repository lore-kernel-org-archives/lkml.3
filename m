Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3HDAdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 20:33:10 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36454 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3HDAdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 20:33:09 -0400
Message-ID: <1375576322.10300.146.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already
 bound correctly
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 03 Aug 2013 18:32:02 -0600
In-Reply-To: <3596381.TNBAQz9C67@vostro.rjw.lan>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan>
	 <1375483118.10300.113.camel@misato.fc.hp.com>
	 <3596381.TNBAQz9C67@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-03 at 02:47 +0200, Rafael J. Wysocki wrote:
> On Friday, August 02, 2013 04:38:38 PM Toshi Kani wrote:
> > On Fri, 2013-08-02 at 00:33 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Modify acpi_bind_one() so that it doesn't fail if the device
> > > represented by its first argument has already been bound to the
> > > given ACPI handle (second argument), because that is not a good
> > > enough reason for returning an error code.
> > 
> > While it seems reasonable to allow such case, I do not think we will hit
> > this case under the normal scenarios.  So, I do not think we need to
> > make this change now unless it actually solves Yasuaki's issue (which I
> > am guessing not).
> 
> In theory it should be possible to call acpi_bind_one() twice in a row
> for the same dev and the same handle without failure, that simply is
> logical.  The patch may not fix any problems visible now, but returning an
> error code in such a case is simply incorrect.

We changed acpi_bus_device_attach() to not call the handler or driver
again if it is already bound.  So, I was under impression that we
prevent from attaching a same device twice.  But I may be missing
something...

Thanks,
-Toshi


