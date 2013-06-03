Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3FCDGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3FCDGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:06:23 -0400
Message-ID: <51AC0815.4030707@redhat.com>
Date: Mon, 03 Jun 2013 11:05:57 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Subject: Re: [net-next rfc V2 6/8] macvtap: allow TUNSETIFF to create multiqueue
 device
References: <1369994005-5943-1-git-send-email-jasowang@redhat.com> <1369994005-5943-7-git-send-email-jasowang@redhat.com> <51A8B829.7040708@cogentembedded.com>
In-Reply-To: <51A8B829.7040708@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 10:48 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 31-05-2013 13:53, Jason Wang wrote:
>
>> Though the queue were in fact created by open(), we still need to add
>> this check
>> to be compatible with tuntap which can let mgmt software use a single
>> API to
>> manage queues. This patch only validates the device name and moves
>> the TUNSETIFF
>> to a helper.
>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/macvtap.c |   51
>> ++++++++++++++++++++++++++++++++++++++----------
>>   1 files changed, 40 insertions(+), 11 deletions(-)
>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index e76484c..eac49cb 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -870,6 +870,7 @@ out:
>>       return ret;
>>   }
>>
>> +
>
>    Seems like random whitespace change.

Will remove it thanks.
>
>>   static struct macvlan_dev *macvtap_get_vlan(struct macvtap_queue *q)
>>   {
>>       struct macvlan_dev *vlan;
> [...]
>
> WBR, Sergei
>

