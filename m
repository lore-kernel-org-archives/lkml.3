Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3CDOVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:21:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35693 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3CDOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:21:09 -0500
Message-ID: <5134ADC7.3060000@oracle.com>
Date: Mon, 04 Mar 2013 09:20:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
References: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com> <1362393685.16460.16.camel@x61.thuisdomein>
In-Reply-To: <1362393685.16460.16.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 05:41 AM, Paul Bolle wrote:
> On Wed, 2013-01-30 at 21:00 -0500, Sasha Levin wrote:
>> I'm not sure why, but the hlist for each entry iterators were conceived
>> differently from the list ones. While the list ones are nice and elegant:
>>
>>         list_for_each_entry(pos, head, member)
>>
>> The hlist ones were greedy and wanted an extra parameter:
>>
>>         hlist_for_each_entry(tpos, pos, head, member)
>>
>> Why did they need an extra pos parameter? I'm not quite sure. Not only
>> they don't really need it, it also prevents the iterator from looking
>> exactly like the list iterator, which is unfortunate.
>>
>> Besides the semantic patch, there was some manual work required:
>>
>>  - Fix up the actual hlist iterators in linux/list.h
>>  - Fix up the declaration of other iterators based on the hlist ones.
>>  - A very small amount of places were using the 'node' parameter, this
>>  was modified to use 'obj->member' instead.
>>  - Coccinelle didn't handle the hlist_for_each_entry_safe iterator
>>  properly, so those had to be fixed up manually.
> 
> This patch seems to have become commit
> b67bfe0d42cac56c512dd5da4b1b347a23f4b70a in v3.9-rc1. It triggers this
> (obviously correct) warning:
>     net/9p/trans_virtio.c:350:1: warning: ‘p9_virtio_zc_request’ defined but not used [-Wunused-function]
> 
>> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
>> index fd05c81..d7a3fe3 100644
>> --- a/net/9p/trans_virtio.c
>> +++ b/net/9p/trans_virtio.c
>> @@ -655,7 +655,7 @@ static struct p9_trans_module p9_virtio_trans = {
>>  	.create = p9_virtio_create,
>>  	.close = p9_virtio_close,
>>  	.request = p9_virtio_request,
>> -	.zc_request = p9_virtio_zc_request,
>> +	//.zc_request = p9_virtio_zc_request,
>>  	.cancel = p9_virtio_cancel,
>>  	/*
>>  	 * We leave one entry for input and one entry for response
> 
> Why was that line commented out? There's no comment nor is there
> anything in the commit explanation on this change.

uh... what.

I'm not sure what happened there, I'll send a patch to fix it though.

Thanks for the catch!

