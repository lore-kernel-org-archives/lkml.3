Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3CQXUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:20:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41249 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab3CQXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:20:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot on HP 6730B - bisected
Date: Mon, 18 Mar 2013 00:27:03 +0100
Message-ID: <2925166.8AVI1SWGSM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51457F9F.7000204@infracom.it>
References: <513D8F3A.8030308@gmail.com> <12541380.EkF6PjBYxc@vostro.rjw.lan> <51457F9F.7000204@infracom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 17, 2013 09:32:31 AM Roberto Oppedisano wrote:
> Il 17/03/2013 01:59, Rafael J. Wysocki ha scritto:
> > On Saturday, March 16, 2013 08:10:11 AM Roberto Oppedisano wrote:
> >> Il 15/03/2013 18:13, Rafael J. Wysocki ha scritto:
> >>>> Here's the new suspect:
> >>>>
> >>>> f95988de06ea62ef5bd861f06e9ef56cea405ed1 is the first bad commit
> >>>> commit f95988de06ea62ef5bd861f06e9ef56cea405ed1
> >>>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>> Date:   Mon Jan 7 21:17:02 2013 +0100
> >>>>
> >>>>        ACPI / scan: Treat power resources in a special way
> >>> In that case, please try to comment out the following two lines:
> >>>
> >>> 	device_set_wakeup_capable(dev, true);
> >>> 	acpi_pci_sleep_wake(pci_dev, false);
> >>>
> >>> in pci_acpi_setup() in drivers/pci/pci-acpi.c and see if that improves things
> >>> for you.
> >> Current git still hangs with those two lines commented out.
> > What about commenting out the entire contents of pci_acpi_setup(), then?
> 
> Still no luck, still hangs at boot.
> 
> > Also, please send the output of acpidump from the affected machine.
> 
> You can find acpidump and dmesg at:
> 
> http://62.196.71.254/kernel/acpidump.gz
> http://62.196.71.254/kernel/dmesg.txt.gz
> 
> I noticed that booting with serial console enabled succeeds also with 
> failing kernels;
> I've to do more testing to see if it's a 100% success ratio.
> 
> dmesg is relative to vanilla current git kernel, booted without docking 
> station and with serial
> console enabled. Inside it you can find some acpi related error; I don't 
> know if they're relevant.

Thanks for the files.

Please try to boot with initcall_debug in the kernel command line and see
if that works around the problem and if not, whether or not it provides a
clue about the point where boot is stuck (and if that point is always the
same).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
