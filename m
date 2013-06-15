Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3FOWpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 18:45:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38740 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab3FOWpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 18:45:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
Date: Sun, 16 Jun 2013 00:54:59 +0200
Message-ID: <2139297.LeMhgEjsya@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <18797091.iPZsNWFGi1@vostro.rjw.lan>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <8974656.5GmDyxHW7F@vostro.rjw.lan> <18797091.iPZsNWFGi1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 11:20:40 PM Rafael J. Wysocki wrote:
> On Saturday, June 15, 2013 10:17:42 PM Rafael J. Wysocki wrote:

[...]

> 
> Which sysfs interfaces do you mean, by the way?
> 
> If you mean "eject", then it takes acpi_scan_lock and hotplug_dock_devices()
> should always be run under acpi_scan_lock too.  It isn't at the moment,
> because write_undock() doesn't take acpi_scan_lock(), but this is an obvious
> bug (so I'm going to send a patch to fix it in a while).
> 
> With that bug fixed, the possible race between acpi_eject_store() and
> hotplug_dock_devices() should be prevented from happening, so perhaps we're
> worrying about something that cannot happen?

So here's a question: What particular races are possible if we remove
ds->hp_lock entirely without doing anything else just yet?  I mean, how to
*trigger* them from the start to the end and not how they can possibly happen
but never do, because there's no way they can be actually triggered?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
