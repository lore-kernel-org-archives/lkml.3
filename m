Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaJGT2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:28:10 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:47780 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJGT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:28:04 -0400
MIME-Version: 1.0
Date: Tue, 7 Oct 2014 21:28:02 +0200
Message-ID: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
Subject: High latency while CPU is under full load
From: Grozdan <neutrino8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Basically, my problem is this:

I'm doing a lot of audio/video encoding on an AMD FX8350. The encoder
process always runs at nice 10. Even so, my whole system feels very
sluggish. Switching between different app windows and/or virtual
desktops takes up usually 3-5 seconds giving the impression that there
is not enough processing power. Browsing the web is also severely
impacted.

I had to tune CFS in order to be (much) more responsive during an
encoding session. This has worked out pretty well thus far, but it is
my opinion that the user should *not* need to fiddle with buttons to
make his system respond fluently even under high load. The below is
what I had to do in order to get a snappy system during such load

kernel.sched_nr_migrate = 64
kernel.sched_latency_ns = 65000000
kernel.sched_wakeup_granularity_ns = 100000
kernel.sched_min_granularity_ns = 100000
kernel.sched_migration_cost_ns = 7000000

I have tried 3 different kernels, including one compiled myself, but
the results are the same
Kernels I tried were: 3.11.10, 3.12 and 3.16.4 (self-compiled)

My system specs are as follows

CPU: AMD FX-8350 @ 4GHz
RAM: 16GB DDR1333
GPU: NVIDIA GTX 560 with NV blob driver
HDD: Seagate Constellation ES.3 128MB cache
Desktop: KDE 4.11

-- 
Yours truly
