Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FYXYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:24:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34919 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:24:29 -0400
Date: Tue, 25 Jun 2013 16:24:29 -0700 (PDT)
Message-Id: <20130625.162429.966445706450575614.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, edumazet@google.com,
        nhorman@tuxdriver.com, netdev@vger.kernel.org, bhubbard@redhat.com
Subject: Re: [PATCH net] tun: fix recovery from gup errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C7BB8C.70304@redhat.com>
References: <20130623141903.GA21029@redhat.com>
	<51C7BB8C.70304@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 24 Jun 2013 11:22:52 +0800

> On 06/23/2013 10:19 PM, Michael S. Tsirkin wrote:
>> get user pages might fail partially in tun zero copy
>> mode. To recover we need to put all pages that we got,
>> but code used a wrong index resulting in double-free
>> errors.
>>
>> Reported-by: Brad Hubbard <bhubbard@redhat.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>
>> I haven't figured out why do we get failures,
>> but recovery is clearly wrong.
>>
>> This is also -stable material.
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

Applied with the missing empty line added, I was tired of waiting for
Michael to take care of this himself.
