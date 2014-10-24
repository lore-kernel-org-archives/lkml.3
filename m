Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbaJXQIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:08:19 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:26033 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbaJXQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:08:18 -0400
Date: Fri, 24 Oct 2014 12:08:15 -0400
From: Eric B Munson <emunson@akamai.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Commit 35ce7f29a breaks hibernation for XPS 13
Message-ID: <20141024160815.GA2968@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

As of 3.18-rc1 I can no longer hibernate my Dell XPS-13.  Bisect points
the finger at 35ce7f29a.  A revert of that commit confirms, I can once
again hibernate my machine without it.

When the hibernation fails I see this in dmesg:
[   37.953313] PM: Syncing filesystems ... done.
[   37.963694] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   37.965297] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
[   37.965299] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
[   37.965301] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
[   37.965304] PM: Marking nosave pages: [mem 0xc496a000-0xc4b6bfff]
[   37.965315] PM: Marking nosave pages: [mem 0xdadb7000-0xdcffefff]
[   37.965479] PM: Marking nosave pages: [mem 0xdd000000-0xffffffff]
[   37.966000] PM: Basic memory bitmaps created
[   37.966046] PM: Preallocating image memory... done (allocated 181989 pages)
[   38.141524] PM: Allocated 727956 kbytes in 0.17 seconds (4282.09 MB/s)
[   38.141525] Freezing remaining freezable tasks ... 
[   58.151863] Freezing of tasks failed after 20.004 seconds (0 tasks refusing to freeze, wq_busy=1):
[   58.151894] 
[   58.151896] Restarting kernel threads ... done.
[   58.181915] PM: Basic memory bitmaps freed
[   58.181917] Restarting tasks ... done.


I am not sure what else I can provide that might be useful, but I did
see the thread on net-dev about this same commit.  Please CC me on any
fixes and I will be happy to test.

Eric
