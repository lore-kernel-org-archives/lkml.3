Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3G3DjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:39:25 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:40169 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3G3DjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:39:24 -0400
Message-ID: <51F73555.1020204@huawei.com>
Date: Tue, 30 Jul 2013 11:39:01 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <libo.chen@huawei.com>
Subject: Re: [PATCH 7/9] syslog_ns: implement function for creating syslog
 ns
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-8-git-send-email-rui.xiang@huawei.com> <51F64313.4010700@cn.fujitsu.com>
In-Reply-To: <51F64313.4010700@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/29 18:25, Gu Zheng wrote:
> Hi Rui,
> 
> On 07/29/2013 10:31 AM, Rui Xiang wrote:
> 
>> Add create_syslog_ns function to create a new ns. We
>> must create a user_ns before create a new syslog ns.
>> And then tie the new syslog_ns to current user_ns
>> instead of original syslog_ns which comes from
>> parent user_ns.

...

>> diff --git a/kernel/printk.c b/kernel/printk.c
>> index fd2d600..6b561db 100644
>> --- a/kernel/printk.c
>> +++ b/kernel/printk.c
>> @@ -384,6 +384,10 @@ static int check_syslog_permissions(int type, bool from_file,
>>  		|| type == SYSLOG_ACTION_CONSOLE_LEVEL)
>>  		ns = &init_syslog_ns;
>>  
>> +	/* create a new syslog ns */
>> +	if (type == SYSLOG_ACTION_NEW_NS)
>> +		return 0;
>> +
> 
> Don't we need further permission or caps check here? Return success directly seems sloppy. 
> 
CAP_SYSLOG is checked in create_syslog_ns, so I think we can return 0 temporarily.



