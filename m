Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaK0AUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:20:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56008 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753682AbaK0AU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:20:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in core code
Date: Thu, 27 Nov 2014 01:37:13 +0100
Message-ID: <37310416.jZXoh5nfSC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After commit b2b49ccbdd54 "PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected" (currently in Linux next) CONFIG_PM_RUNTIME is set whenever
CONFIG_PM is set, so CONFIG_PM can be used in #ifdefs instead of
CONFIG_PM_RUNTIME which simplifies things in quite a few cases.

For this reason, the following patches modify some core code to use
CONFIG_PM instead of CONFIG_PM_RUNTIME.

[1/4] Drop a macro which is redundant after the above commit.
[2/4] Use PM instead of PM_RUNTIME in the core device PM code.
[3/4] Use PM instead of PM_RUNTIME in the ACPI core.
[4/4] Use PM instead of PM_RUNTIME in the PCI core.

They build for me for all of the relevant combinations of options (on x86),
but more testing (on the other architectures) would be welcome.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
