Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaEAHic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:38:32 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35644 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaEAHib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140430141924.8d84f7fdcac3ac3996802aa9@linux-foundation.org>
References: <20140429025310.GA5913@devel>
	<20140430141924.8d84f7fdcac3ac3996802aa9@linux-foundation.org>
Date: Thu, 1 May 2014 16:38:31 +0900
Message-ID: <CAHb8M2DSRmKDNq4faBg6OUza6auUfXAJLNmUMMqbQxJQG4e6Cw@mail.gmail.com>
Subject: Re: [PATCH] dmapool: remove redundant NULL check for dev in dma_pool_create()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-01 6:19 GMT+09:00, Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 29 Apr 2014 11:53:10 +0900 Daeseok Youn <daeseok.youn@gmail.com>
> wrote:
>
>> "dev" cannot be NULL because it is already checked before
>> calling dma_pool_create().
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> If dev can be NULL, it has NULL deferencing when kmalloc_node()
>> is called after enabling CONFIG_NUMA.
>
> hm, this is unclear.
>
> The code which handles the dev==NULL case was obviously put there
> deliberately, presumably with the intention of permitting drivers to
> call dma_pool_create() without a device*.  This code is very old.
>
> A lot of drivers call dma_pool_create() (I doubt if you audited all of
> them!) and perhaps there are some which use this feature and have never
> been run on NUMA hardware.
Yes.. I didn't check all of callers.. sorry about that. Some drivers
are checked.
>
> I think I'll apply the patch anyway because such drivers (if they
> exist) probably need some attending to.
>
> I rewrote the changelog thusly:
>
>
> : "dev" cannot be NULL because it is already checked before calling
> : dma_pool_create().
> :
> : If dev ever was NULL, the code would oops in dev_to_node() after enabling
> : CONFIG_NUMA.
> :
> : It is possible that some driver is using dev==NULL and has never been run
> : on a NUMA machine.  Such a driver is probably outdated, possibly buggy
> and
> : will need some attention if it starts triggering NULL derefs.
>
>
Ok. Thanks for kind explanation.
Regards,
Daeseok Youn
