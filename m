Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaESAw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:52:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaESAw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:52:56 -0400
Date: Sun, 18 May 2014 20:52:55 -0400 (EDT)
Message-Id: <20140518.205255.1720822944120407928.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sparc: add renameat2 syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJfpegsyE4TCo5VBG2K2q=2hrnDN5kgZ_Qt-KUvwDSfcq1oitA@mail.gmail.com>
References: <CAJfpegsAUQZ0mxpqOeVj2SERT41Caw77irBHSTPMc0CaQp=uYA@mail.gmail.com>
	<20140515.124931.1801842437410594819.davem@davemloft.net>
	<CAJfpegsyE4TCo5VBG2K2q=2hrnDN5kgZ_Qt-KUvwDSfcq1oitA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 17:52:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 16 May 2014 11:09:02 +0200

> On Thu, May 15, 2014 at 6:49 PM, David Miller <davem@davemloft.net> wrote:
>> From: Miklos Szeredi <miklos@szeredi.hu>
>> Date: Thu, 15 May 2014 14:22:33 +0200
>>
>>> On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> From: Miklos Szeredi <mszeredi@suse.cz>
>>>>
>>>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>>>> Cc: David S. Miller <davem@davemloft.net>
>>>
>>> David,
>>>
>>> I'll be sending a batch of patches with arch support for the renameat2
>>> syscall to Linus next week.  If you'd like me to send this as well,
>>> could you please ACK it?
>>
>> For the 32-bit compat case on sparc64, you need to add a wrapper to
>> sign extend the oldfd and newfd arguments.
>>
>> This usually occurs in arch/sparc/kernel/sys32.S, probably something
>> like:
>>
>> SIGN2(sys32_renameat2, sys_renameat2, %o0, %o2)
>>
>> and then you hook up sys32_renameat2 instead of sys_renameat2 in the
>> 32-bit compat syscall table in syscall_64.S
> 
> Are you sure?  None of the *at() functions (including renameat())  are in there.

Those are in error too.

Any argument which is signed needs this treatment.
