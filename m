Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3ALCbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 21:31:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab3ALCbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:31:10 -0500
Message-ID: <50F0CAE9.2080303@redhat.com>
Date: Sat, 12 Jan 2013 10:31:05 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@redhat.com>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tuntap: forbid calling TUNSETIFF when detached
References: <1357894242-25020-1-git-send-email-jasowang@redhat.com> <20130111144236.GC2310@stefanha-thinkpad.muc.redhat.com>
In-Reply-To: <20130111144236.GC2310@stefanha-thinkpad.muc.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 10:42 PM, Stefan Hajnoczi wrote:
> On Fri, Jan 11, 2013 at 04:50:41PM +0800, Jason Wang wrote:
>> @@ -1546,6 +1544,9 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>  	struct net_device *dev;
>>  	int err;
>>  
>> +	if (rcu_dereference_protected(tfile->detached, lockdep_rtnl_is_held()))
>> +		return -EINVAL;
>> +
> How come none of the other tfile->detached users call rcu_*()?

Right, no need to use rcu, the access were protected by rtnl lock.

Will repost.
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

