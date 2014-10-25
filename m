Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaJYStW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:49:22 -0400
Received: from mail.efficios.com ([78.47.125.74]:36418 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaJYStS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:49:18 -0400
Date: Sat, 25 Oct 2014 12:51:25 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: lttng-dev <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <465653369.1985.1414241485934.JavaMail.zimbra@efficios.com>
In-Reply-To: <1254279794.1957.1414240389301.JavaMail.zimbra@efficios.com>
Subject: Progress on system crash traces with LTTng using DAX and pmem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: Progress on system crash traces with LTTng using DAX and pmem
Thread-Index: IcW4w43a7FMs0w2LdwfVPXVz5te3yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, Hi Ross,

A quick follow up on my progress on using DAX and pmem with
LTTng. I've been able to successfully gather a user-space
trace into buffers mmap'd into an ext4 filesystem within
a pmem block device mounted with -o dax to bypass the page
cache. After a soft reboot, I'm able to mount the partition
again, and gather the very last data collected in the buffers
by the applications. I created a "lttng-crash" program that
extracts data from those buffers and converts the content
into a readable Common Trace Format trace. So I guess
you have a use-case for your patchsets on commodity hardware
right there. :)

I've been asked by my customers if DAX would work well with
mtd-ram, which they are using. To you foresee any roadblock
with this approach ?

FYI, the main reason why my customer wants to go with a
"trace into memory that survives soft reboot" approach
rather than to use things like kexec/kdump is that they
care about the amount of time it takes to reboot their
machines. They want a solution where they can extract the
detailed crash data after reboot, after the machine is
back online, rather than requiring a few minutes of offline
time to extract the crash details.

So I guess next year I'll probably be looking into
allocating the LTTng kernel tracer buffers into an mmap'd file
within a ext2/4-DAX-over-pmem/mtd-ram filesystem. It's going
to be exciting! :)

Please keep me in CC on your next patch versions. I'm willing
to spend some more time reviewing them if needed. By the way,
do you guys have a target time-frame/kernel version you aim
at for getting this work upstream ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
