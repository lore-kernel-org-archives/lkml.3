Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3EXGVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3EXGV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:21:28 -0400
Message-ID: <519F06D8.6030605@redhat.com>
Date: Fri, 24 May 2013 14:21:12 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 3/8] macvtap: introduce macvtap_get_vlan()
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com> <1369278753-2533-4-git-send-email-jasowang@redhat.com> <519E318B.2010804@cogentembedded.com>
In-Reply-To: <519E318B.2010804@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 11:11 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 23-05-2013 7:12, Jason Wang wrote:
>
>> Factor out the device holding logic to a macvtap_get_vlan(), this
>> will be also
>> used by multiqueue API.
>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/macvtap.c |   26 +++++++++++++++++++-------
>>   1 files changed, 19 insertions(+), 7 deletions(-)
>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index ce1c72a..a36e49e 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -890,6 +890,23 @@ out:
>>       return ret;
>>   }
>>
>> +static struct macvlan_dev *macvtap_get_vlan(struct macvtap_queue *q)
>> +{
>> +    struct macvlan_dev *vlan;
>
>    Empty line wouldn't hurt here, after declaration.

Will add one line here. Thanks
>
>> +    rcu_read_lock_bh();
>> +    vlan = rcu_dereference_bh(q->vlan);
>> +    if (vlan)
>> +        dev_hold(vlan->dev);
>> +    rcu_read_unlock_bh();
>> +
>> +    return vlan;
>> +}
> [...]
>
> WBR, Sergei
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

