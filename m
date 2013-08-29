Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab3H2VIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:08:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43009 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3H2VIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:08:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 0/3] ACPI / hotplug / mm: Rework mutual exclusion between hibernation and memory hotplug
Date: Thu, 29 Aug 2013 23:12:53 +0200
Message-ID: <9589253.Co8jZpnWdd@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

One thing that bothers me quite a bit about memory hotplug is that
lock_hotplug_memory() acquires pm_mutex which is kind of a blunt thing
and has a huge potential for deadlocks.

This can be avoided if device_hotplug_lock is held around hibernation,
which is not too difficult to make happen and hence the following patch
series.

[1/3] ACPI: Acquire device_hotplug_lock before acpi_scan_lock (this is
      necessary, because hibernation acquires acpi_scan_lock in linux-next).

[2/3] PM / hibernate: Allocate memory bitmaps after freezing user space
      processes (the reason why is explained in the changelog).

[3/3] Rework mutual exclusion between hibernation and memory hotplug.

On top of linux-pm.git/linux-next.

Thanks,
Rafael

