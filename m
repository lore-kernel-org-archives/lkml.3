Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaKDUHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:07:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:07:05 -0500
Date: Tue, 04 Nov 2014 15:07:01 -0500 (EST)
Message-Id: <20141104.150701.1883825026786055864.davem@davemloft.net>
To: joe@perches.com
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] esp4: remove assignment in if condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415129631.23168.3.camel@perches.com>
References: <1415129311-12480-1-git-send-email-fabf@skynet.be>
	<1415129631.23168.3.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 12:07:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 04 Nov 2014 11:33:51 -0800

> On Tue, 2014-11-04 at 20:28 +0100, Fabian Frederick wrote:
> 
> trivia:
> 
>> diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
> []
>> @@ -392,8 +392,11 @@ static int esp_input(struct xfrm_state *x, struct sk_buff *skb)
>>  	if (elen <= 0)
>>  		goto out;
>>  
>> -	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
>> +	err = skb_cow_data(skb, 0, &trailer);
>> +
>> +	if (err < 0)
>>  		goto out;
> 
> Generally it's better/more common to use
> 
> 	foo = bar();
> 	if (!foo)
> 		[error_handler...]
> 	
> without the blank line between the set
> and the test.

+1
