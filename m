Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3G1J51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 05:57:27 -0400
Received: from mail-lb0-f193.google.com ([209.85.217.193]:44725 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3G1J50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 05:57:26 -0400
MIME-Version: 1.0
Date: Sun, 28 Jul 2013 15:27:24 +0530
Message-ID: <CALHRZurovUkQboM_o-q7U-EK6n5zJ78vcoNEc1HFv=-R52wMvA@mail.gmail.com>
Subject: [RFC] Request for suggestions
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

AXI bus Monitor(AM) has set of counters which are used to collect
metrics related to AXI transactions happening between Masters and Slaves
in an AXI system. Example metrics which can be calculated using AM are
as below:
Read Latency
Write Latency
Idle Read/Write Cycle counts
Number of Transactions
Number of Bytes transferred
Number of Read/Write Last signals issued.
etc.,
AM raises interrupts during counter overflows and there is Sample Interval
down counter which raises interrupt and takes snapshot of all counters and
stores in set of registers. Use case for this IP will be as follows:
User confiures his required metrics to be collected by Counters.
User sets Sample Interval down counter depending on the metrics
monitoring sampling rate.
Start counters.
Collect metrics data when AM issues Sample Interval
down Counter interrupt.

What would be the appropriate framework/interface of Linux Driver for AM?
I have been thinking of interfaces-
UIO
Char
sysfs
The main problem I see is signalling interrupts to Userspace.
Please suggest me the best interface.

Thanks,
Sundeep
