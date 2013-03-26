Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3CZWqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:46:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43799 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab3CZWqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:46:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI, ACPI: hold acpi_scan_lock during root bus hotplug
Date: Tue, 26 Mar 2013 23:54:12 +0100
Message-ID: <2166148.RX0m5V0khX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVSZd216JrdHdeLSrr1k0d5xTCmLz9FH151BHDDo8KRAQ@mail.gmail.com>
References: <1673357.1IdxNNvGWX@vostro.rjw.lan> <34989330.IyIZ6Qqfxh@vostro.rjw.lan> <CAE9FiQVSZd216JrdHdeLSrr1k0d5xTCmLz9FH151BHDDo8KRAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 26, 2013 08:12:30 AM Yinghai Lu wrote:
> On Tue, Mar 26, 2013 at 6:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, March 10, 2013 10:05:16 PM Yinghai Lu wrote:
> >> During merging pci tree with pm/acpi tree, Linus noticed that
> >> we don't have same lock using patten about acpi pci root as
> >> acpiphp.
> >>
> >> Here apply same lock patten, and we need to change
> >> acpi_bus_hot_remove_device executing via acpi_os_hotplug_execute()
> >> as it also hold the lock in acpi_bus_hot_remove_device.
> >>
> >> That will make acpi_bus_hot_remove_device calling the same as other
> >> callers.
> >>
> >> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Bjorn, this needs to go in before final 3.9.
> >
> > Are you going to handle it, or should I take care of it?
> 
> It should be better via your pm+acpi tree, as that lock is added via your tree.

OK, I'll take it, then, if Bjorn doesn't object.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
