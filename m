Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3HADME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:12:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52613 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3HADMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:12:02 -0400
Message-ID: <51F9D1F6.4080001@jp.fujitsu.com>
Date: Wed, 31 Jul 2013 23:11:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de, dave@linux.vnet.ibm.com
Subject: Re: [PATCH resend] drop_caches: add some documentation and info message
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz> <20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
In-Reply-To: <20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/fs/drop_caches.c
>> +++ b/fs/drop_caches.c
>> @@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
>>  	if (ret)
>>  		return ret;
>>  	if (write) {
>> +		printk(KERN_INFO "%s (%d): dropped kernel caches: %d\n",
>> +		       current->comm, task_pid_nr(current), sysctl_drop_caches);
>>  		if (sysctl_drop_caches & 1)
>>  			iterate_supers(drop_pagecache_sb, NULL);
>>  		if (sysctl_drop_caches & 2)
> 
> How about we do
> 
> 	if (!(sysctl_drop_caches & 4))
> 		printk(....)
> 
> so people can turn it off if it's causing problems?

The best interface depends on the purpose. If you want to detect crazy application,
we can't assume an application co-operate us. So, I doubt this works.

