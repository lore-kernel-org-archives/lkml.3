Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaBZQf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:35:28 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39627 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbaBZQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:35:26 -0500
Message-ID: <530E17C7.1030504@free-electrons.com>
Date: Wed, 26 Feb 2014 17:35:19 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Regression with wait_event_timeout in next-20140226
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while testing next-20140226 I got an issue with the function
wait_event_timeout. When this function timed out instead of returning
0, it returned the value of the timeout passed in parameter. I found
that reverting "sched/wait: Suppress Sparse 'variable shadowing'
warning" fixed this regression.

I got this issue in the driver drivers/i2c/busses/i2c-mv64xxx.c.


Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
