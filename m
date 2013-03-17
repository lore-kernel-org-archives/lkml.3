Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3CQAwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 20:52:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34809 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab3CQAwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 20:52:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot on HP 6730B - bisected
Date: Sun, 17 Mar 2013 01:59:23 +0100
Message-ID: <12541380.EkF6PjBYxc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51441AD3.9080700@infracom.it>
References: <513D8F3A.8030308@gmail.com> <2481455.MbROdCkzQM@vostro.rjw.lan> <51441AD3.9080700@infracom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 16, 2013 08:10:11 AM Roberto Oppedisano wrote:
> Il 15/03/2013 18:13, Rafael J. Wysocki ha scritto:
> >> Here's the new suspect:
> >>
> >> f95988de06ea62ef5bd861f06e9ef56cea405ed1 is the first bad commit
> >> commit f95988de06ea62ef5bd861f06e9ef56cea405ed1
> >> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Date:   Mon Jan 7 21:17:02 2013 +0100
> >>
> >>       ACPI / scan: Treat power resources in a special way
> > In that case, please try to comment out the following two lines:
> >
> > 	device_set_wakeup_capable(dev, true);
> > 	acpi_pci_sleep_wake(pci_dev, false);
> >
> > in pci_acpi_setup() in drivers/pci/pci-acpi.c and see if that improves things
> > for you.
> 
> Current git still hangs with those two lines commented out.

What about commenting out the entire contents of pci_acpi_setup(), then?

Also, please send the output of acpidump from the affected machine.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
