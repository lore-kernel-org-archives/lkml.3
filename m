Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaGHXU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:20:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55015 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaGHXU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:20:28 -0400
Date: Tue, 08 Jul 2014 16:20:27 -0700 (PDT)
Message-Id: <20140708.162027.1804045121900039101.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: kevin.curtis@farsite.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] farsync: fix invalid memory accesses in fst_add_one()
 and fst_init_card()
From: David Miller <davem@davemloft.net>
In-Reply-To: <53BC7360.6050000@ispras.ru>
References: <1404516950-17900-1-git-send-email-khoroshilov@ispras.ru>
	<20140708.152057.490185410038470309.davem@davemloft.net>
	<53BC7360.6050000@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 16:20:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Tue, 08 Jul 2014 18:40:32 -0400

> On 08.07.2014 18:20, David Miller wrote:
>> From: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> Date: Sat,  5 Jul 2014 03:35:50 +0400
>>
>>> -                }
>>> +			card->nports = i;
>>> +			return (card->nports == 0) ? err : 0;
>>> +		}
>> I don't think this is the right thing to do.
>>
>> This will cause the caller to not free the IRQ or any of the
>> other resources.
> My understanding of the existing code is to proceed if at least one port
> is available.
> So I return error code if no ports available at all, otherwise
> initialization continues and can succeed.
> If something else goes wrong, all resources are deallocated.
> 
> Do you suggest to return error code unconditionally?

Yes, that is my suggestion.

I'm also weary of so many changes to a driver that gets so little
usage and probably next to no testing at all.
