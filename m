Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaKJHaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:30:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38048 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaKJHaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:30:05 -0500
Date: Mon, 10 Nov 2014 02:30:00 -0500 (EST)
Message-Id: <20141110.023000.1275181784917275552.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, mst@redhat.com
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141110065817.GG7996@ZenIV.linux.org.uk>
References: <20141109211908.GF7996@ZenIV.linux.org.uk>
	<20141110.002020.1062493586889118565.davem@davemloft.net>
	<20141110065817.GG7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Nov 2014 23:30:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 10 Nov 2014 06:58:17 +0000

> On Mon, Nov 10, 2014 at 12:20:20AM -0500, David Miller wrote:
>> From: Al Viro <viro@ZenIV.linux.org.uk>
>> Date: Sun, 9 Nov 2014 21:19:08 +0000
>> 
>> > 1) does sparc64 access_ok() need to differ for 32bit and 64bit tasks?
>> 
>> sparc64 will just fault no matter what kind of task it is.
>> 
>> It is impossible for a user task to generate a reference to
>> a kernel virtual address, as kernel and user accesses each
>> go via a separate address space identifier.
> 
> Sure, but why do we have access_ok() there at all?  I.e. why not just have
> it constant 1?

Since access_ok() is in fact constant 1 on sparc64, where we use it,
does it really matter?
