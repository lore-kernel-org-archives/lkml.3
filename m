Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3LJHvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:51:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61482 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3LJHvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:51:20 -0500
X-IronPort-AV: E=Sophos;i="4.93,864,1378828800"; 
   d="scan'208";a="9228834"
Message-ID: <52A6C792.3010500@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 15:49:38 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: mqueue perf data
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 15:51:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 15:51:00,
	Serialize complete at 2013/12/10 15:51:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,


Do we need to stat out the perf data of mqueue test in kernel_selftests?
It's like following.

Thanks,
Wanlong Gao



# make run_tests -C mqueue
make: Entering directory `/git/linux/tools/testing/selftests/mqueue'

Initial system state:
	Using queue path:		/test1
	RLIMIT_MSGQUEUE(soft):		819200
	RLIMIT_MSGQUEUE(hard):		819200
	Maximum Message Size:		8192
	Maximum Queue Size:		10
	Default Message Size:		8192
	Default Queue Size:		10

Adjusted system state for testing:
	RLIMIT_MSGQUEUE(soft):		819200
	RLIMIT_MSGQUEUE(hard):		819200
	Maximum Message Size:		8192
	Maximum Queue Size:		10
	Default Message Size:		8192
	Default Queue Size:		10


Test series 1, behavior when no attr struct passed to mq_open:
Kernel supports setting defaults separately from maximums:		PASS
Given sane values, mq_open without an attr struct succeeds:		PASS
Kernel properly honors default setting knobs:				PASS
Kernel properly limits default values to lesser of default/max:		PASS
Kernel properly fails to create queue when defaults would
exceed rlimit:								PASS


Test series 2, behavior when attr struct is passed to mq_open:
Queue open in excess of rlimit max when euid = 0 failed:		PASS
Queue open with mq_maxmsg > limit when euid = 0 succeeded:		PASS
Queue open with mq_msgsize > limit when euid = 0 succeeded:		PASS
Queue open with total size > 2GB when euid = 0 failed:			PASS
Queue open in excess of rlimit max when euid = 99 failed:		PASS
Queue open with mq_maxmsg > limit when euid = 99 failed:		PASS
Queue open with mq_msgsize > limit when euid = 99 failed:		PASS
Queue open with total size > 2GB when euid = 99 failed:			PASS

Initial system state:
	Using queue path:			/mq_perf_tests
	RLIMIT_MSGQUEUE(soft):			819200
	RLIMIT_MSGQUEUE(hard):			819200
	Maximum Message Size:			8192
	Maximum Queue Size:			10
	Nice value:				0

Adjusted system state for testing:
	RLIMIT_MSGQUEUE(soft):			(unlimited)
	RLIMIT_MSGQUEUE(hard):			(unlimited)
	Maximum Message Size:			16777216
	Maximum Queue Size:			65530
	Nice value:				-20
	Continuous mode:			(disabled)
	CPUs to pin:				3

	Queue /mq_perf_tests created:
		mq_flags:			O_NONBLOCK
		mq_maxmsg:			65530
		mq_msgsize:			16
		mq_curmsgs:			0

	Started mqueue performance test thread on CPU 3
		Max priorities:			32768
		Clock resolution:		1 nsec

	Test #1: Time send/recv message, queue empty
		(10000000 iterations)
		Send msg:			4.50690280s total time
						405 nsec/msg
		Recv msg:			4.123621560s total time
						412 nsec/msg

	Test #2a: Time send/recv message, queue full, constant prio
		(100000 iterations)
		Filling queue...done.		0.14554407s
		Testing...done.
		Send msg:			0.40292962s total time
						402 nsec/msg
		Recv msg:			0.40605786s total time
						406 nsec/msg
		Draining queue...done.		0.15010003s

	Test #2b: Time send/recv message, queue full, increasing prio
		(100000 iterations)
		Filling queue...done.		0.25628197s
		Testing...done.
		Send msg:			0.53792862s total time
						537 nsec/msg
		Recv msg:			0.52323416s total time
						523 nsec/msg
		Draining queue...done.		0.17617835s

	Test #2c: Time send/recv message, queue full, decreasing prio
		(100000 iterations)
		Filling queue...done.		0.26939894s
		Testing...done.
		Send msg:			0.55733128s total time
						557 nsec/msg
		Recv msg:			0.51363749s total time
						513 nsec/msg
		Draining queue...done.		0.19254167s

	Test #2d: Time send/recv message, queue full, random prio
		(100000 iterations)
		Filling queue...done.		0.28530211s
		Testing...done.
		Send msg:			0.59583951s total time
						595 nsec/msg
		Recv msg:			0.55122718s total time
						551 nsec/msg
		Draining queue...done.		0.19537439s
make: Leaving directory `/git/linux/tools/testing/selftests/mqueue'
