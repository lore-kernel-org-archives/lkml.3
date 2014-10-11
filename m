Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaJKVO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 17:14:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45344 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJKVOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 17:14:25 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 0/2] kernel: Drop pm_poweroff_prepare
Date: Sat, 11 Oct 2014 14:14:15 -0700
Message-Id: <1413062057-11657-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the poweroff handler implementation, I also started looking
into pm_power_off_prepare. Ultimately, I concluded that it is not really
necessary, and that it would be easy to remove.

The first patch in this series converts acpi to use a syscore callback
instead of setting pm_power_off_prepare. Since acpi is the only user of
pm_power_off_prepare, it is no longer used and removed with the second
patch.

Removing pm_power_off_prepare streamlines poweroff handling and makes it
more uniform, so I think its removal would be worthwhile to consider.

I am sending the series as RFC since I am not sure if I may be missing
something. Compile tested only at this time; I'll do more testing if this
sounds like a reasonable thing to do.

On a side note, I don't see any callers of acpi_suspend(). I actually
removed it as an experiment, and at least x86_64:allmodconfig still
compiles. Can it be removed ?
