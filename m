Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaI1JFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:05:44 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53502 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaI1JFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:05:42 -0400
Date: Sun, 28 Sep 2014 12:05:38 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: kernel:[ 1155.839866] NMI watchdog: BUG: soft lockup - CPU#2 stuck
 for 22s! [kworker/u8:5:71]
Message-ID: <alpine.LRH.2.11.1409281201160.9728@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying yesterdays 3.17 git snapshot on a i5-2400 + intel graphics 
computer, it seems to go into soft lockup. Still pings but no ssh to it 
any more, and active ssh session got the following kind of NMI watchdog 
soft lockups during aptitude list update:

essage from syslogd@ilves at Sep 27 11:43:55 ...
 kernel:[ 1015.866355] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u8:5:71]

Message from syslogd@ilves at Sep 27 11:44:23 ...
 kernel:[ 1043.861061] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u8:5:71]

Message from syslogd@ilves at Sep 27 11:44:51 ...
 kernel:[ 1071.855791] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u8:5:71]

Message from syslogd@ilves at Sep 27 11:45:19 ...
 kernel:[ 1099.850501] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u8:5:71]

Message from syslogd@ilves at Sep 27 11:45:47 ...
 kernel:[ 1127.845192] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u8:5:71]

Message from syslogd@ilves at Sep 27 11:46:15 ...
 kernel:[ 1155.839866] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u8:5:71]


3.16 ran fine.

This was remote reboot into the new kernel, so only graphics usage is 
kms console on i915 + kdm login screen. Only user-initiaded action was 
ssh connection with dmesg, su -, aptitude and aptitude list update from 
there.

-- 
Meelis Roos (mroos@linux.ee)
