Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3KGBZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:25:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50043 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3KGBZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:25:16 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <527AE1CA.7030703@oracle.com>
References: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com> <527AE1CA.7030703@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH] xen/balloon: Set balloon's initial state to number of existing RAM pages
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 06 Nov 2013 20:25:04 -0500
To: Bob Liu <bob.liu@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Message-ID: <7ae8615f-36f4-4c28-a147-c522335ba8f7@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Liu <bob.liu@oracle.com> wrote:
>
>On 11/07/2013 04:37 AM, Boris Ostrovsky wrote:
>> Currently balloon's initial value is set to max_pfn which includes
>> non-RAM ranges such as MMIO hole. As result, initial memory target
>> (specified by guest's configuration file) will appear smaller than
>> what balloon driver perceives to be the current number of available
>> pages. Thus it will balloon down "extra" pages, decreasing amount of
>> available memory for no good reason.
>> 
>
>This fix the strange behavior I mentioned yesterday, every time after
>guest started balloon driver will be triggered unreasonably.
>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>>  drivers/xen/balloon.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
>> index b232908..1b62304 100644
>> --- a/drivers/xen/balloon.c
>> +++ b/drivers/xen/balloon.c
>> @@ -641,7 +641,7 @@ static int __init balloon_init(void)
>>  
>>  	balloon_stats.current_pages = xen_pv_domain()
>>  		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
>> -		: max_pfn;
>> +		: get_num_physpages();
>
>By the way, should the other places using max_pfn also be changed with
>get_num_physpages()?

No. In PV that calculation is correct as it gets the amount of RAM pages - which is a exactly what you need.
>
>>  	balloon_stats.target_pages  = balloon_stats.current_pages;
>>  	balloon_stats.balloon_low   = 0;
>>  	balloon_stats.balloon_high  = 0;
>> 


