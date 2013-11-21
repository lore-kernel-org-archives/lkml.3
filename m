Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3KUNOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:14:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59150 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751154Ab3KUNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:14:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jeremy Compostella <jeremy.compostella@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Compostella <jeremy.compostella@gmail.com>,
        "Gross, Mark" <mark.gross@intel.com>
Subject: Re: [PATCH] acpi: Incorrect ACPI tables walk in acpi_tables_sysfs_init
Date: Thu, 21 Nov 2013 14:27:22 +0100
Message-ID: <10117757.kh27mk2tn6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <87bo1e839w.fsf@tldlab276.tl.intel.com>
References: <87bo1e839w.fsf@tldlab276.tl.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 11:20:27 AM Jeremy Compostella wrote:
> Date: Thu, 21 Nov 2013 11:20:23 +0100
> Message-ID: <87d2lu83a0.fsf@tldlab276.tl.intel.com>
> MIME-Version: 1.0
> Content-Type: text/plain
> --text follows this line--
> Hi,
> 
> When executing on a ACPI Hardware reduced hardware, all the ACPI tables are not
> exposed in sysfs due to the fact that FACS is silently ignored by the kernel in
> ACPI hardware reduced and, moreover, the acpi_tables_sysfs_init ACPI table walk
> is buggy and stop too soon.
> 
> The acpi_tables_sysfs_init function should to rely on the appropriate
> acpi_status return values to decide or not to stop the iteration.  This way,
> when running on a ACPI Reduced Harware environment where the FACS table is
> silently ignored by the kernel or some ACPI table are not correctly memory
> mapped or have a bad checksum it would not stop the iteration.
> 
> Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>

Since this is a fix, I've modified the subject and changelog slightly and
queued up the patch for the next ACPI pull request (next week).

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
