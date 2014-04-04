Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaDDDTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:19:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30321 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbaDDDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:19:17 -0400
From: Lei Wen <leiwen@marvell.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <leiwen@marvell.com>
Subject: [PATCH 0/3] switch printk timestamp to use booting time
Date: Fri, 4 Apr 2014 11:18:39 +0800
Message-ID: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-04_01:2014-04-03,2014-04-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404030304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very common to have many processor to run over the same machine
but run different OS actually, so that timestamp alignment is key
to do the right debugging when find something wrong.

Linux adopt schedule clock stopped, so that printk timestamp would get
during suspend period which break such assumption in the old days.
So this patch set is supposed to recover such behavior again.

BTW, I am not sure whether we could add additional member in printk
log structure, so that we could print out two piece of log with
one including suspend time, while another not?

Lei Wen (3):
  time: create __get_monotonic_boottime for WARNless calls
  timekeeping: move clocksource init to the early place
  printk: using booting time as the timestamp

 include/linux/time.h      |  2 ++
 init/main.c               |  1 +
 kernel/printk/printk.c    |  4 ++--
 kernel/time/timekeeping.c | 55 ++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 48 insertions(+), 14 deletions(-)

-- 
1.8.3.2

