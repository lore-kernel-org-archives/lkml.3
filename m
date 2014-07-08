Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaGHWkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:40:40 -0400
Received: from mail.ispras.ru ([83.149.199.45]:54666 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaGHWki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:40:38 -0400
Message-ID: <53BC7360.6050000@ispras.ru>
Date: Tue, 08 Jul 2014 18:40:32 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kevin.curtis@farsite.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] farsync: fix invalid memory accesses in fst_add_one()
 and fst_init_card()
References: <1404516950-17900-1-git-send-email-khoroshilov@ispras.ru> <20140708.152057.490185410038470309.davem@davemloft.net>
In-Reply-To: <20140708.152057.490185410038470309.davem@davemloft.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.2014 18:20, David Miller wrote:
> From: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Date: Sat,  5 Jul 2014 03:35:50 +0400
>
>> -                }
>> +			card->nports = i;
>> +			return (card->nports == 0) ? err : 0;
>> +		}
> I don't think this is the right thing to do.
>
> This will cause the caller to not free the IRQ or any of the
> other resources.
My understanding of the existing code is to proceed if at least one port
is available.
So I return error code if no ports available at all, otherwise
initialization continues and can succeed.
If something else goes wrong, all resources are deallocated.

Do you suggest to return error code unconditionally?

--
Alexey

