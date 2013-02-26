Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab3BZXdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:33:21 -0500
Received: from relay3.sgi.com ([192.48.152.1]:53513 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753604Ab3BZXdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:33:20 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: johnstul@us.ibm.com, tglx@linutronix.de, sboyd@codeaurora.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v3 0/2] timer_list: Fix /proc/timer_list failure on 4096 cpus
Date: Tue, 26 Feb 2013 17:33:14 -0600
Message-Id: <1361921596-9636-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <51267626.3030308@codeaurora.org>
References: <51267626.3030308@codeaurora.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 4096 cores attemping to read /proc/timer_list
fails because we are trying to push all the data into a single
kmalloc buffer.

A better solution is to not us the single_open mechanism but to
provide our own seq_operations and treat each cpu as an
individual record.

The output should be identical to the previous version.

v2: Added comments on the iteration and other fixups pointed to by Andrew.
v3: Corrected the case where max_cpus != nr_cpu_ids by exiting early.

Nathan Zimmer (2):
  timer_list: split timer_list_show_tickdevices()
  timer_list: convert timer list to be a proper seq_file

 kernel/time/timer_list.c | 111 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 19 deletions(-)

-- 
1.8.1.2

