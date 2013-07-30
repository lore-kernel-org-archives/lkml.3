Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3G3IwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:52:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56499 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3G3IwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:52:15 -0400
Message-ID: <51F77E7D.20608@huawei.com>
Date: Tue, 30 Jul 2013 16:51:09 +0800
From: Xue jiufei <xuejiufei@huawei.com>
Reply-To: <xuejiufei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <xuejiufei@huawei.com>
CC: <oleg@redhat.com>, <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: call_usermodehelper() returns -513 when ocfs2 umounting filesystems
References: <51F76BA0.4000007@huawei.com>
In-Reply-To: <51F76BA0.4000007@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.87]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 15:30, Xue jiufei wrote:
> Hi, 
> We have encountered an error when umounting ocfs2 filesystems.
> Function ocfs2_leave_group() calls call_usermodehelper() to stop
> heartbeat thread, but it returns -513(ERESTARTNOINTR) in one test.
> And after that error, every times umounting the filesystem, it
> returns the same error.
> And at the same time, there's another kworker thread which is
> sending messages to other nodes always return return errno
> -512(ERESTARTSYS). So I think these two threads may have
> pending signals remain.
> This error can not reproduced any longer. Has any ideas?
> 
> The log is as follows:
> [58463.684504] (kworker/u:1,17332,0):o2net_send_tcp_msg:1332 ERROR: sendmsg returned -512 instead of 104
> [58915.213299] ocfs2: Error -513 running user helper "/usr/sbin/ocfs2_hb_ctl -K -u A5FD0ED8733D4F9C98D23B326AD7DE10"
> [59406.443615] ocfs2: Error -513 running user helper "/usr/sbin/ocfs2_hb_ctl -K -u A5FD0ED8733D4F9C98D23B326AD7DE10"
> 
> Thanks.
> 		--joyce
The kernel version is 3.0.58.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


