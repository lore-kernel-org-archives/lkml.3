Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3LFRON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:14:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40269 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3LFROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:14:12 -0500
Date: Fri, 06 Dec 2013 12:14:11 -0500 (EST)
Message-Id: <20131206.121411.2205219888474731457.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: ydroneaud@opteya.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: handle error more gracefully in socketpair()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131206104805.GM10323@ZenIV.linux.org.uk>
References: <1386285331.18074.47.camel@localhost.localdomain>
	<20131205.194355.1677309681391704143.davem@davemloft.net>
	<20131206104805.GM10323@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 09:14:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 6 Dec 2013 10:48:05 +0000

> On Thu, Dec 05, 2013 at 07:43:55PM -0500, David Miller wrote:
>> From: Yann Droneaud <ydroneaud@opteya.com>
>> Date: Fri, 06 Dec 2013 00:15:31 +0100
>> 
>> > AFAIK, using sys_close() seems to be the exception, and writing the file
>> > descriptor before installing it is the more or less the norm.
>> 
>> What other system call in the kernel writes a file descriptor's value
>> into the address space of a user process before the file descriptor
>> is actually usable?
>> 
>> That's really terrible semantically.
> 
> What's the problem with that?  If nothing else, shared descriptor table is
> a lot more visible to other threads than two-element array, most likely
> in stack frame of whoever makes that syscall...
> 
> As for your question, how about pipe(2)?

Fair enough, Yann please resubmit your patch.

Thanks.
