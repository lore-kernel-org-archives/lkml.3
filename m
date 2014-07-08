Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaGHEfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:35:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48857 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaGHEfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:35:02 -0400
Date: Mon, 07 Jul 2014 21:35:01 -0700 (PDT)
Message-Id: <20140707.213501.964032202172502145.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arcnet: Remove "#define bool int"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404303121-2548-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404303121-2548-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 21:35:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  2 Jul 2014 14:12:01 +0200

> The header file include/linux/arcdevice.h #defines bool to int, if
> bool is not already #defined. However, the files which use that header
> file seem to rely on that #define (unconditionally) being in effect:
> the prototypes for the functions arcrimi_reset, com20020_reset,
> com90io_reset, com90xx_reset (whose addresses are assigned to the
> hw.reset member of struct arcnet_local) use int explicitly.
> 
> Moreover, that #define is an accident waiting to happen (scenario:
> inclusion of arcdevice.h followed by inclusion of some header which
> declares function prototypes using bool). Also, #include
> <linux/types.h> must appear before #include <linux/arcdevice.h> (the
> compiler wouldn't like "typedef _Bool int").
> 
> Since none of the files using arcdevice.h declare variables of type
> "bool", the patch is actually quite simple, unlike the commit message.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied to net-next, thanks.
