Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbaEIVqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:46:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50237 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757815AbaEIVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:46:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: next-20140409 Bad Kconfig help text in drivers/acpi/Kconfig
Date: Sat, 10 May 2014 00:03:28 +0200
Message-ID: <1700408.9j4GRJaOLE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <25850.1399660010@turing-police.cc.vt.edu>
References: <25850.1399660010@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 02:26:50 PM Valdis Kletnieks wrote:
> 
> --==_Exmh_1399660010_2033P
> Content-Type: text/plain; charset=us-ascii
> 
> So this commit landed in linux-next recently:
> 
> commit e2a7c3d7812369daae56f069eab2e8f3e548d231
> Author: Lan Tianyu <tianyu.lan@intel.com>
> Date:   Sun May 4 11:07:24 2014 +0800
> 
>     ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
> 
>     The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
>     directory and breaks some old userspace tools. This patch
>     is to revert 7d7ee95.
> 
>     Fixes: 7d7ee958867a (ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c)
> 
> The problem is that it really needs a follow-on patch to fix this help text:
> 
>     This option has no effect on /proc/acpi/ directories
>     and functions, which do not yet exist in /sys
>     This option, together with the proc directories, will be
>     deleted in 2.6.39.
> 
> Somebody want to pick a new release target and try again?

Do you mean something like this:

---
 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/Kconfig
===================================================================
--- linux-pm.orig/drivers/acpi/Kconfig
+++ linux-pm/drivers/acpi/Kconfig
@@ -60,7 +60,7 @@ config ACPI_PROCFS_POWER
 	  This option has no effect on /proc/acpi/ directories
 	  and functions, which do not yet exist in /sys
 	  This option, together with the proc directories, will be
-	  deleted in 2.6.39.
+	  deleted in the future.
 
 	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
 

