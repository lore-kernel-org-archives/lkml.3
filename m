Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3G3Stx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:49:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab3G3StA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:49:00 -0400
Date: Tue, 30 Jul 2013 11:49:00 -0700 (PDT)
Message-Id: <20130730.114900.5636932806999400.davem@davemloft.net>
To: joe@perches.com
Cc: gregkh@linuxfoundation.org, hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH v3 1/3] net/usb/r815x: replace USB buffer from stack to
 DMA-able
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375209677.2075.129.camel@joe-AO722>
References: <20130730140059.GE27962@kroah.com>
	<20130730.113329.1450325193505423812.davem@davemloft.net>
	<1375209677.2075.129.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 11:49:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 30 Jul 2013 11:41:17 -0700

> On Tue, 2013-07-30 at 11:33 -0700, David Miller wrote:
>> From: Greg KH <gregkh@linuxfoundation.org>
>> Date: Tue, 30 Jul 2013 07:00:59 -0700
>> 
>> > This call is so slow, you can afford to make a call to kmalloc for the
>> > data, as it sure just did for other structures it needed :)
>> 
>> I told him to implement things this way, to avoid calling kmalloc every
>> single register access.
>> 
>> Using kmalloc all the time makes the access fragile, since a badly timed
>> call during high memory pressure can fail.
>> 
>> I'd rather the potential failure happen at one time, probe time.
>> 
>> In any event, Ming Lei has suggested using usbnet_{read,write}_cmd()
>> instead, which sounds like a good solution to this problem.
> 
> Those do per-call allocs too.

Sigh...  Ok I won't fight this any longer then :-)
