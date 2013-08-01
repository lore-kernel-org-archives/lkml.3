Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3HAFhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:37:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3HAFhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:10 -0400
X-IronPort-AV: E=Sophos;i="4.89,791,1367942400"; 
   d="scan'208";a="8084180"
Message-ID: <51F9F452.9060308@cn.fujitsu.com>
Date: Thu, 01 Aug 2013 13:38:26 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rui Xiang <rui.xiang@huawei.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, libo.chen@huawei.com
Subject: Re: [PATCH 4/9] syslog_ns: make syslog handling per namespace
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-5-git-send-email-rui.xiang@huawei.com> <51F9BBAB.1080306@cn.fujitsu.com> <51F9D1A2.406@huawei.com>
In-Reply-To: <51F9D1A2.406@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 13:34:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 13:34:54,
	Serialize complete at 2013/08/01 13:34:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 11:10 AM, Rui Xiang wrote:
> On 2013/8/1 9:36, Gao feng wrote:
>> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>>> This patch makes syslog buf and other fields per
>>> namespace.
>>>
>>> Here use ns->log_buf(log_buf_len, logbuf_lock,
>>> log_first_seq, logbuf_lock, and so on) fields
>>> instead of global ones to handle syslog.
>>>
>>> Syslog interfaces such as /dev/kmsg, /proc/kmsg,
>>> and syslog syscall are all containerized for
>>> container users.
>>>
>>
>> /dev/kmsg is used by the syslog api closelog, openlog, syslog, vsyslog,
>> this should be per user namespace, but seems in your patch,
> 
> Yes, /dev/kmsg is per user namespace, and per syslog ns, too.
> 
>> the syslog message generated through these APIs on host can be exported
>> to the /dev/kmsg of container, is this want we want?
>>
> Ah.. I think your question targets at devkmsg_writev function, right? 

yep, another small problem, you forgot to remove the global logbuf_lock.

> You remind me that it's really an issue. Printk_emit in devkmsg_writev 
> should not use init_syslog_ns as its syslog_ns but current_user_ns->syslog_ns.
> 
> In 1st version, current_syslog_ns was used in vprintk_emit. In this version,
> the interface vprintk_emit has changed, but this patch misses that.
> I will fix it.
> 

Ok, thanks!
