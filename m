Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBWXG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:06:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63129 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752233AbaBWXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:06:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/2] ACPI / PCI / PM: Delay resuming runtine-suspended devices during system-suspend
Date: Mon, 24 Feb 2014 00:18:22 +0100
Message-ID: <1853950.oxM3KDpyLu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The PCI bus type and the ACPI PM domain resume runtime-suspended devices during
their .prepare() callbacks, which is suboptimal.

One problem caused by that is increasing the time of system suspend if there
are many runtime-suspended devices to resume during it (because the .prepare()
callbacks are executed sequentially).

The following two patches are intended to improve that one aspect slightly
in those two subsystems.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
