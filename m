Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3ALCbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 21:31:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab3ALCbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:31:34 -0500
Message-ID: <50F0CB00.30100@redhat.com>
Date: Sat, 12 Jan 2013 10:31:28 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 1/2] tuntap: forbid calling TUNSETIFF when detached
References: <1357894242-25020-1-git-send-email-jasowang@redhat.com> <1357916147.27446.3653.camel@edumazet-glaptop>
In-Reply-To: <1357916147.27446.3653.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 10:55 PM, Eric Dumazet wrote:
> On Fri, 2013-01-11 at 16:50 +0800, Jason Wang wrote:
>
>>  
>> +	if (rcu_dereference_protected(tfile->detached, lockdep_rtnl_is_held()))
>> +		return -EINVAL;
>> +
> Thats an open coded rtnl_dereference()
>
> (please cleanup the whole tun.c file)
>

Sure.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

