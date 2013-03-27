Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3C0A4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:56:37 -0400
Received: from relay1.sgi.com ([192.48.179.29]:47954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab3C0A4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:56:36 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v5 0/2] timer_list: Fix /proc/timer_list failure on 4096 cpus
Date: Tue, 26 Mar 2013 19:56:28 -0500
Message-Id: <1364345790-14577-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <alpine.LFD.2.02.1303251651200.22263@ionos>
References: <alpine.LFD.2.02.1303251651200.22263@ionos>
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
v5: Use seq_open_private and supply a proper iterator rather then a big mess. 

Nathan Zimmer (2):
  timer_list: split timer_list_show_tickdevices
  timer_list: convert timer list to be a proper seq_file

 kernel/time/timer_list.c | 104 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 83 insertions(+), 21 deletions(-)

-- 
1.8.1.2

