Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAPAqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:46:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43015 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:46:49 -0500
Date: Wed, 15 Jan 2014 16:46:49 -0800 (PST)
Message-Id: <20140115.164649.533508366980529205.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] virtio-net: drop rq->max and rq->num
From: David Miller <davem@davemloft.net>
In-Reply-To: <87zjmwvlzl.fsf@rustcorp.com.au>
References: <1388134685-30691-1-git-send-email-jasowang@redhat.com>
	<87mwixx670.fsf@rustcorp.com.au>
	<87zjmwvlzl.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 16 Jan 2014 10:25:26 +1030

> Rusty Russell <rusty@rustcorp.com.au> writes:
>> Jason Wang <jasowang@redhat.com> writes:
>>> It looks like there's no need for those two fields:
>>>
>>> - Unless there's a failure for the first refill try, rq->max should be always
>>>   equal to the vring size.
>>> - rq->num is only used to determine the condition that we need to do the refill,
>>>   we could check vq->num_free instead.
>>> - rq->num was required to be increased or decreased explicitly after each
>>>   get/put which results a bad API.
>>>
>>> So this patch removes them both to make the code simpler.
>>
>> Nice.  These fields date from when the vq struct was opaque.
>>
>> Applied,
>> Rusty.
> 
> Oops, this doesn't require any core virtio changes, so it's for DaveM:
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Jason please repost this with Rusty's ACK, thanks.
