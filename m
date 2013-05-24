Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3EXG2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab3EXG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:28:43 -0400
Message-ID: <519F088C.1020509@redhat.com>
Date: Fri, 24 May 2013 14:28:28 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 2/8] macvtap: return -EBADFD when TUNGETIFF fails
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com> <1369278753-2533-3-git-send-email-jasowang@redhat.com> <20130523115423.GF17993@redhat.com>
In-Reply-To: <20130523115423.GF17993@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 07:54 PM, Michael S. Tsirkin wrote:
> On Thu, May 23, 2013 at 11:12:27AM +0800, Jason Wang wrote:
>> Tuntap return -EBADFD when TUNGETIFF fails, we should return the same value.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Can you add some more comments on why this matters?

Just to keep compatibility for tuntap.
> Any userspace that cares will have to handle both, right?

Ideally the userspace should expect the same behavior for both tap and
macvtap.

Maybe we should just keep this.
>
>> ---
>>  drivers/net/macvtap.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index 59e9605..ce1c72a 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -928,7 +928,7 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
>>  		rcu_read_unlock_bh();
>>  
>>  		if (!vlan)
>> -			return -ENOLINK;
>> +			return -EBADFD;
>>  
>>  		ret = 0;
>>  		if (copy_to_user(&ifr->ifr_name, vlan->dev->name, IFNAMSIZ) ||
>> -- 
>> 1.7.1

