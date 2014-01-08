Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaAHBRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:17:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbaAHBRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:17:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,621,1384272000"; 
   d="scan'208";a="9387193"
Message-ID: <52CCA748.4080709@cn.fujitsu.com>
Date: Wed, 08 Jan 2014 09:18:00 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org, rgb@redhat.com,
        eparis@redhat.com
Subject: Re: [PATCH 1/2] audit: print error message when fail to create audit
 socket
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com> <20140107165335.c276557412291786d745e0ab@linux-foundation.org>
In-Reply-To: <20140107165335.c276557412291786d745e0ab@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/08 09:16:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/08 09:16:01,
	Serialize complete at 2014/01/08 09:16:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 08:53 AM, Andrew Morton wrote:
> On Tue, 17 Dec 2013 11:10:41 +0800 Gao feng <gaofeng@cn.fujitsu.com> wrote:
> 
>> print the error message and then return -ENOMEM.
>>
>> ...
>>
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -1083,12 +1083,11 @@ static int __net_init audit_net_init(struct net *net)
>>  	pr_info("audit: initializing netlink socket in namespace\n");
>>  
>>  	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
>> -	if (aunet->nlsk == NULL)
>> -		return -ENOMEM;
>> -	if (!aunet->nlsk)
>> +	if (aunet->nlsk == NULL) {
>>  		audit_panic("cannot initialize netlink socket in namespace");
>> -	else
>> -		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
>> +		return -ENOMEM;
>> +	}
>> +	aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
>>  	return 0;
>>  }
> 
> What kernel version are these against?  Something ancient, I expect -
> audit_net_init() doesn't exist.
> 
> Please check current kernels, redo and resend the patches if anything
> needs changing?

This patch is against Richard Guy Briggs's audit tree. the current kernel
doesn't have this problem.

BTW, Richard & Eric, when do you plan to push these changes to the upstream?
there are a lot of changes in Richard's tree.
