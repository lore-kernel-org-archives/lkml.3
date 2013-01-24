Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AXDXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab3AXDXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:23:00 -0500
Message-ID: <5100A90C.2030406@redhat.com>
Date: Thu, 24 Jan 2013 11:22:52 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org
Subject: Re: [PATCH 2/2] tuntap: limit the number of flow caches
References: <1358949553-30309-1-git-send-email-jasowang@redhat.com> <1358949553-30309-2-git-send-email-jasowang@redhat.com> <20130123.135024.1407137924304146015.davem@davemloft.net>
In-Reply-To: <20130123.135024.1407137924304146015.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 02:50 AM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed, 23 Jan 2013 21:59:13 +0800
>
>> We create new flow caches when a new flow is identified by tuntap, This may lead
>> some issues:
>>
>> - userspace may produce a huge amount of short live flows to exhaust host memory
>> - the unlimited number of flow caches may produce a long list which increase the
>>   time in the linear searching
>>
>> Solve this by introducing a limit of total number of flow caches.
>>
>> Cc: Stephen Hemminger <stephen@networkplumber.org>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
> Applied, but really flow caches are an extremely broken concept especially
> when external entities control the population of such caches.
>
> We removed the routing cache of the ipv4 networking code exactly because
> this kind of crap does not work at all.
>
> Next you're going to have to add a delicately managed garbage
> collection scheme for this tuntap flow cache, and that will be tuned
> endlessly, when the real issue is that fundamentally this does not
> work.
>
> Instead, make the full lookup scale properly and use appropriate data
> structures.  It won't be as fast as a simple hash table demux, but
> it'll actually be immune to growth issues and DoS attacks and give
> consistent and repeatable lookup performance regardless of traffic
> patterns.

Ok, I will rework it in 3.9.

Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

