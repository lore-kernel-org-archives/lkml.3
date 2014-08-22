Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaHVSaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:30:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:30:21 -0400
Date: Fri, 22 Aug 2014 11:30:19 -0700 (PDT)
Message-Id: <20140822.113019.1690922235326790002.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: ariel.elior@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: broadcom: bnx2x: Remove redundant #ifdef
From: David Miller <davem@davemloft.net>
In-Reply-To: <87mwaxrnbg.fsf@rasmusvillemoes.dk>
References: <1408540489-1795-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140821.213750.2151406448495608410.davem@davemloft.net>
	<87mwaxrnbg.fsf@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 11:30:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Fri, 22 Aug 2014 09:33:07 +0200

> David Miller <davem@davemloft.net> writes:
> 
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Date: Wed, 20 Aug 2014 15:14:49 +0200
>>
>>> Nothing defines _ASM_GENERIC_INT_L64_H, it is a weird way to check for
>>> 64 bit longs, and u64 should be printed using %llx anyway.
>>> 
>>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> It's not correct and will warn on some platforms where "u64" is just
>> a plain "unsigned long".
>>
>> Ie. all of those which use include/asm-generic/int-l64.h
> 
> Of which there are none; that file no longer exists (as I said, nothing
> defines that macro). Please see 0c79a8e2 ("asm/types.h: Remove
> include/asm-generic/int-l64.h") and 2a7930bd
> ("Documentation/printk-formats.txt: No casts needed for u64/s64").

Ok that makes sense, applied, thank you.
