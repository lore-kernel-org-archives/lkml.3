Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3G3Dq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:46:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3G3Dq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:46:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,774,1367942400"; 
   d="scan'208";a="8064173"
Message-ID: <51F7362A.3030509@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 11:42:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rui Xiang <rui.xiang@huawei.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, gaofeng@cn.fujitsu.com,
        libo.chen@huawei.com
Subject: Re: [PATCH 7/9] syslog_ns: implement function for creating syslog
 ns
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-8-git-send-email-rui.xiang@huawei.com> <51F64313.4010700@cn.fujitsu.com> <51F73555.1020204@huawei.com>
In-Reply-To: <51F73555.1020204@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 11:44:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 11:44:13,
	Serialize complete at 2013/07/30 11:44:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:39 AM, Rui Xiang wrote:

> On 2013/7/29 18:25, Gu Zheng wrote:
>> Hi Rui,
>>
>> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>>
>>> Add create_syslog_ns function to create a new ns. We
>>> must create a user_ns before create a new syslog ns.
>>> And then tie the new syslog_ns to current user_ns
>>> instead of original syslog_ns which comes from
>>> parent user_ns.
> 
> ...
> 
>>> diff --git a/kernel/printk.c b/kernel/printk.c
>>> index fd2d600..6b561db 100644
>>> --- a/kernel/printk.c
>>> +++ b/kernel/printk.c
>>> @@ -384,6 +384,10 @@ static int check_syslog_permissions(int type, bool from_file,
>>>  		|| type == SYSLOG_ACTION_CONSOLE_LEVEL)
>>>  		ns = &init_syslog_ns;
>>>  
>>> +	/* create a new syslog ns */
>>> +	if (type == SYSLOG_ACTION_NEW_NS)
>>> +		return 0;
>>> +
>>
>> Don't we need further permission or caps check here? Return success directly seems sloppy. 
>>
> CAP_SYSLOG is checked in create_syslog_ns, so I think we can return 0 temporarily.

If so, why not move the check here? IMO, permission checking is the earlier the better,
what's your opinion?

Regards,
Gu

> 
> 
> 
> 


