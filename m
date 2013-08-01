Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3HADLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:11:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:60228 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HADLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:11:30 -0400
Message-ID: <51F9D1A2.406@huawei.com>
Date: Thu, 1 Aug 2013 11:10:26 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <libo.chen@huawei.com>
Subject: Re: [PATCH 4/9] syslog_ns: make syslog handling per namespace
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-5-git-send-email-rui.xiang@huawei.com> <51F9BBAB.1080306@cn.fujitsu.com>
In-Reply-To: <51F9BBAB.1080306@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/1 9:36, Gao feng wrote:
> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>> This patch makes syslog buf and other fields per
>> namespace.
>>
>> Here use ns->log_buf(log_buf_len, logbuf_lock,
>> log_first_seq, logbuf_lock, and so on) fields
>> instead of global ones to handle syslog.
>>
>> Syslog interfaces such as /dev/kmsg, /proc/kmsg,
>> and syslog syscall are all containerized for
>> container users.
>>
> 
> /dev/kmsg is used by the syslog api closelog, openlog, syslog, vsyslog,
> this should be per user namespace, but seems in your patch,

Yes, /dev/kmsg is per user namespace, and per syslog ns, too.

> the syslog message generated through these APIs on host can be exported
> to the /dev/kmsg of container, is this want we want?
>
Ah.. I think your question targets at devkmsg_writev function, right? 
You remind me that it's really an issue. Printk_emit in devkmsg_writev 
should not use init_syslog_ns as its syslog_ns but current_user_ns->syslog_ns.

In 1st version, current_syslog_ns was used in vprintk_emit. In this version,
the interface vprintk_emit has changed, but this patch misses that.
I will fix it.


Thanks for your reminder. :)


