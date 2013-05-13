Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3EMR40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:56:26 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19242 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab3EMR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:56:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363132800"; 
   d="scan'208";a="24904316"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86,time,xen: maintain an accurate persistent clock in more cases
Date: Mon, 13 May 2013 18:56:05 +0100
Message-ID: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel has limited support for updating the persistent clock or
RTC when NTP is synced.  This has the following limitations:

* The persistent clock is not updated on step changes.  This leaves a
  window where it will be incorrect (while NTP resyncs).

* On x86, the virtual platforms have persistent clocks with nanosecond
  precision but this is lost in the x86_platform.set/get_wallclock()
  calls.  Guests may see wallclocks that are out by up to 1 second.

* Xen guests use the Xen wallclock as their persistent clock.  dom0
  maintains this clock so it is persistent for domUs and not dom0
  itself.

These series fixes the above limitations.

Each patch in the series is independent so may be applied to their
respective trees separately.

David

