Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaKBXYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 18:24:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaKBXYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 18:24:35 -0500
Date: Sun, 02 Nov 2014 18:24:30 -0500 (EST)
Message-Id: <20141102.182430.2172669108987505623.davem@davemloft.net>
To: clemens@ladisch.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: Add preprocessor symbols for PAGE_* pgprot_t
 values.
From: David Miller <davem@davemloft.net>
In-Reply-To: <545690D0.5040904@ladisch.de>
References: <545690D0.5040904@ladisch.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Nov 2014 15:24:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>
Date: Sun, 02 Nov 2014 21:15:12 +0100

> Kernel code assumes that the PAGE_* values are preprocessor symbols, and
> that therefore arch support can be checked for with #ifdef.
> 
> At the moment, sparc64 does not implement any of the symbols checked
> for, so these checks happen to work.
> 
> To prevent potential breakage when another #ifdef check is added or when
> sparc64 implements another PAGE_ value, make such #ifdef checks work by
> adding preprocessor symbols on top of the PAGE_* variables.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

"This change actually doesn't have any effect, and doesn't matter,
 so let's make this change."

I really don't buy this.

I'd also rather the kernel use Kconfig based symbols to detect for
arch availability of feature X or Y, assuming things are CPP symbols
is very fragile at best.

I'm not applying this, sorry.  I mean, you didn't even bother to
mention what symbol this does matter for.

