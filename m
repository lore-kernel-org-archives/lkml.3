Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaAFU2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:28:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51199 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754620AbaAFU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:28:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to avoid sysfs warnings
Date: Mon, 06 Jan 2014 21:41:46 +0100
Message-ID: <4679785.iPCX7mECEL@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAE9FiQV1tui+nHMFF419dpTOKt_x4US6R=3uPhDvUDJ0zoMrEg@mail.gmail.com>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan> <2459491.HIKjAnF27k@vostro.rjw.lan> <CAE9FiQV1tui+nHMFF419dpTOKt_x4US6R=3uPhDvUDJ0zoMrEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 11:28:43 AM Yinghai Lu wrote:
> On Thu, Jan 2, 2014 at 4:45 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, January 02, 2014 02:47:04 PM Yinghai Lu wrote:
> >>
> >> No. It should be before removing all root bus devices.
> >> as they need to access the pci devices during stop ioapic and dmar.
> >>
> >> Also ioapic itself could one one pci device.
> >
> > Well, if we stop drivers first, then stop ioapic/dmar and *then* remove
> > devices, it is possible to rebind a driver to a device after ioapic/dmar has
> > been stopped, which I guess will not lead to anything nice?
> 
> Not sure how that could happen.
> 
> If it would really happen, we could set dev->match_driver to 0 in pci_stop_dev.

Simply, run "modprobe -r driver && modprobe driver" in a loop and
remove the PCI host bridge the given device is on in parallel to that.  Chances
are, you'll see some nice breakage.

Also what happens if somebody uses the "remove" sysfs attribute on a device
needed by ioapic/dmar?

Rafael

