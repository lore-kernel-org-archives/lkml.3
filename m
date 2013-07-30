Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab3G3HbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:31:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61669 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3G3HbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:31:22 -0400
Message-ID: <51F76BA0.4000007@huawei.com>
Date: Tue, 30 Jul 2013 15:30:40 +0800
From: Xue jiufei <xuejiufei@huawei.com>
Reply-To: <xuejiufei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <oleg@redhat.com>, <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: call_usermodehelper() returns -513 when ocfs2 umounting filesystems
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.87]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
We have encountered an error when umounting ocfs2 filesystems.
Function ocfs2_leave_group() calls call_usermodehelper() to stop
heartbeat thread, but it returns -513(ERESTARTNOINTR) in one test.
And after that error, every times umounting the filesystem, it
returns the same error.
And at the same time, there's another kworker thread which is
sending messages to other nodes always return return errno
-512(ERESTARTSYS). So I think these two threads may have
pending signals remain.
This error can not reproduced any longer. Has any ideas?

The log is as follows:
[58463.684504] (kworker/u:1,17332,0):o2net_send_tcp_msg:1332 ERROR: sendmsg returned -512 instead of 104
[58915.213299] ocfs2: Error -513 running user helper "/usr/sbin/ocfs2_hb_ctl -K -u A5FD0ED8733D4F9C98D23B326AD7DE10"
[59406.443615] ocfs2: Error -513 running user helper "/usr/sbin/ocfs2_hb_ctl -K -u A5FD0ED8733D4F9C98D23B326AD7DE10"

Thanks.
		--joyce

