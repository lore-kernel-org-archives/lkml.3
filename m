Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3E1SWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:22:54 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51454 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3E1SWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:22:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="26485989"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/2] xen: maintain an accurate persistent clock in more cases
Date: Tue, 28 May 2013 19:22:46 +0100
Message-ID: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
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

* Xen guests use the Xen wallclock as their persistent clock.  dom0
  maintains this clock so it is persistent for domUs and not dom0
  itself.

These series fixes the above limitations and depends on "x86: increase
precision of x86_platform.get/set_wallclock()" which was previously
posted.

Changes since v1:

Reworked to use the pvclock_gtod notifier to sync the wallclock (this
looked similar to what a KVM host does).  update_persistent_clock()
will now only update the CMOS RTC.

David

[1] http://lists.xen.org/archives/html/xen-devel/2013-05/msg01402.html

