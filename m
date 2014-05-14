Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaENUsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:48:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaENUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:48:10 -0400
Date: Wed, 14 May 2014 16:48:05 -0400 (EDT)
Message-Id: <20140514.164805.1312198151357839253.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Use a more standard macro for INET_ADDR_COOKIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400100249.30384.32.camel@joe-AO725>
References: <1400038207.24350.83.camel@joe-AO725>
	<20140514.160845.214090653562722244.davem@redhat.com>
	<1400100249.30384.32.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 May 2014 13:48:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 14 May 2014 13:44:09 -0700

> On Wed, 2014-05-14 at 16:08 -0400, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Tue, 13 May 2014 20:30:07 -0700
>> 
>> > Missing a colon on definition use is a bit odd so
>> > change the macro for the 32 bit case to declare an
>> > __attribute__((unused)) and __deprecated variable.
>> > 
>> > The __deprecated attribute will cause gcc to emit
>> > an error if the variable is actually used.
>> > 
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> 
>> This is fine, applied, thanks Joe.
>> 
>> Perhaps it would have been nicer to make the macros be initializers,
>> so that it still would look like a proper variable declaration at
>> the use sites:
>> 
>> 	const __addrpair var = INET_ADDR_COOKIE(x, y, z);
>> 
>> or something like that.
> 
> Maybe so, but there's no way to add an __attribute__
> before the = sign for the 32 bit case like that without
> another #define and it would then always require
> initialization too.

Good point.
