Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaFXRg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:36:29 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55151 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaFXRg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:36:28 -0400
From: =?windows-1252?Q?Lu=EDs_Tani=E7a?= <matallui@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: [PERF_EVENT 3.11] Group Multiplexing not Working Properly
Date: Tue, 24 Jun 2014 18:36:20 +0100
Message-Id: <DDD31947-22E6-44DB-9969-D73D35BB9659@gmail.com>
Cc: peterz@infradead.org, eranian@google.com
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to configure 8 events in a machine which supports only 4 (so, using multiplexing). I tried different approaches:

	1) Configure 8 events independently (works as expected)
	2) Configure 2 event-sets of 4 events each in counting mode (works as expected)
	3) Configure 2 event-sets of 4 events each in sampling mode (not working right)

In case 3) I also tried different approaches:

	3.a) 1 ring-buffer for each event-set and a callback for the POLL signal
		- only the first ring-buffer was detecting samples
		- the second ring-buffer was empty

	3.b) 1 ring-buffer shared between event-sets (using PERF_EVENT_IOC_SET_OUTPUT)
		- both event-sets were writing to the ring-buffer
		- 1st event-set only writes 2 samples while 2nd event-set writes like 20+ samples
		- samples from 1st event-set report time_enabled=time_running while samples from 2nd don’t

Moreover, in both cases the wakeup_events parameter is not working.
I believe there must be some programming bugs in perf_event while profiling in sampling mode with multiple event-sets (groups).

Regards,
matallui


