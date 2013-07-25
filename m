Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3GYCuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:50:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58803 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3GYCuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:50:11 -0400
Message-ID: <51F09252.3080102@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 10:49:54 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rakib Mullick <rakib.mullick@gmail.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
References: <1374601332.9192.0.camel@localhost.localdomain> <51EF4969.4050807@linux.vnet.ibm.com> <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com> <51EF919F.2000706@linux.vnet.ibm.com> <20130724104931.GF27075@twins.programming.kicks-ass.net>
In-Reply-To: <20130724104931.GF27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072502-4790-0000-0000-0000097328B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 06:49 PM, Peter Zijlstra wrote:
> On Wed, Jul 24, 2013 at 04:34:39PM +0800, Michael Wang wrote:
>> But your patch will run the risk to get a freed sd, since you make
>> 'sd_llc' wrong for a period of time (between destroy and rebuild) IMO.
>>
>> I guess I get you point, you are trying to save one time update since
>> you think this will be done twice, but actually the result of this two
>> time update was different, it's not redo and it's in order to sync
>> 'sd_llc' with 'rq->sd'.
> 
> Michael is right, you cannot skip update_top_cache_domain() when
> destroying things.

Thanks for the confirm :)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

