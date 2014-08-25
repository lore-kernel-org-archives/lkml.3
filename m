Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaHYSr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:47:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaHYSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:47:55 -0400
Date: Mon, 25 Aug 2014 11:47:54 -0700 (PDT)
Message-Id: <20140825.114754.1052522152538122040.davem@davemloft.net>
To: dborkman@redhat.com
Cc: linux@rasmusvillemoes.dk, ffusco@redhat.com, tgraf@suug.ch,
        linux-kernel@vger.kernel.org, matthew@wil.cx, wli@holomorphy.com,
        akpm@linux-foundation.org, nyc@holomorphy.com
Subject: Re: [PATCH/RFC] hash: Let gcc decide how to multiply
From: David Miller <davem@davemloft.net>
In-Reply-To: <53FB32FD.4000603@redhat.com>
References: <1408968804-7295-1-git-send-email-linux@rasmusvillemoes.dk>
	<53FB32FD.4000603@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 11:47:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 25 Aug 2014 14:58:37 +0200

> On 08/25/2014 02:13 PM, Rasmus Villemoes wrote:
>> A 9+ years old comment in hash_64 says that gcc can't optimize
>> multiplication by GOLDEN_RATIO_PRIME_64. Well, compilers get smarter
>> and CPUs get faster all the time, so it is perhaps about time to
>> revisit that assumption.
> 
> Seems fine by me, but Cc'ing a couple of others (as those you have
> Cc'ed
> haven't written that code :)). You might want to let your changes go
> via
> Andrew's tree, too, perhaps ...

You need to test the code generation for a cpu where the multiply
instruction is more expensive than the shifts and adds.
