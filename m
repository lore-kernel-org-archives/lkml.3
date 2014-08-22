Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaHVHdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:33:12 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43403 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaHVHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:33:10 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Miller <davem@davemloft.net>
Cc: ariel.elior@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: broadcom: bnx2x: Remove redundant #ifdef
Organization: D03
References: <1408540489-1795-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140821.213750.2151406448495608410.davem@davemloft.net>
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::VthQ13rZa0knu59q:0000000000000000000000000000000000HOE
X-Hashcash: 1:20:140822:netdev@vger.kernel.org::uYMpy6QTp/IY9gqb:0000000000000000000000000000000000000002E0J
X-Hashcash: 1:20:140822:davem@davemloft.net::nO+MQpi9Xxbftp0c:0000000000000000000000000000000000000000004ZvF
X-Hashcash: 1:20:140822:ariel.elior@qlogic.com::fbp19yeEMWsK9TEE:000000000000000000000000000000000000000AH+I
Date: Fri, 22 Aug 2014 09:33:07 +0200
In-Reply-To: <20140821.213750.2151406448495608410.davem@davemloft.net> (David
	Miller's message of "Thu, 21 Aug 2014 21:37:50 -0700 (PDT)")
Message-ID: <87mwaxrnbg.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date: Wed, 20 Aug 2014 15:14:49 +0200
>
>> Nothing defines _ASM_GENERIC_INT_L64_H, it is a weird way to check for
>> 64 bit longs, and u64 should be printed using %llx anyway.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
> It's not correct and will warn on some platforms where "u64" is just
> a plain "unsigned long".
>
> Ie. all of those which use include/asm-generic/int-l64.h

Of which there are none; that file no longer exists (as I said, nothing
defines that macro). Please see 0c79a8e2 ("asm/types.h: Remove
include/asm-generic/int-l64.h") and 2a7930bd
("Documentation/printk-formats.txt: No casts needed for u64/s64").

Thanks,
Rasmus
