Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3EXFO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab3EXFOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:14:55 -0400
Message-ID: <519EF740.6010804@redhat.com>
Date: Fri, 24 May 2013 13:14:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 4/8] macvlan: reduce the max number of taps to
 8
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com> <1369278753-2533-5-git-send-email-jasowang@redhat.com> <20130523063740.GA14703@redhat.com>
In-Reply-To: <20130523063740.GA14703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 02:37 PM, Michael S. Tsirkin wrote:
> On Thu, May 23, 2013 at 11:12:29AM +0800, Jason Wang wrote:
>> To be same with tap.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Well for tap the very specific reason was that
> there's an array of big queue structures,
> so we need to limit it to make it fit in a page.
> No such reason here right?

Right, one of the reason is that the flow caches itself occupies too
much space, I'd move it out of tun_struct.
>
> We need at least as much as tap to be compatible, so
> let's just make it 16 unconditionally?

Ok, in fact we can make it even more.
>
>> ---
>>  include/linux/if_macvlan.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
>> index e47ad46..32e943a 100644
>> --- a/include/linux/if_macvlan.h
>> +++ b/include/linux/if_macvlan.h
>> @@ -50,7 +50,7 @@ struct macvlan_pcpu_stats {
>>   * Maximum times a macvtap device can be opened. This can be used to
>>   * configure the number of receive queue, e.g. for multiqueue virtio.
>>   */
>> -#define MAX_MACVTAP_QUEUES	(NR_CPUS < 16 ? NR_CPUS : 16)
>> +#define MAX_MACVTAP_QUEUES	8
>>  
>>  #define MACVLAN_MC_FILTER_BITS	8
>>  #define MACVLAN_MC_FILTER_SZ	(1 << MACVLAN_MC_FILTER_BITS)
>> -- 
>> 1.7.1

