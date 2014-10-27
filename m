Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaJ0Wnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:43:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaJ0Wnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:43:31 -0400
Date: Mon, 27 Oct 2014 18:43:27 -0400 (EDT)
Message-Id: <20141027.184327.1734954193920971940.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, steve.capper@linaro.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141027140938.142f83a4c3bc6512dd73b54c@linux-foundation.org>
References: <20141024.133249.71272218161411159.davem@davemloft.net>
	<CA+55aFyqtuh53PmwO65NtM_PrPd51=EMWiv8dU8bNTrXL59=Jg@mail.gmail.com>
	<20141027140938.142f83a4c3bc6512dd73b54c@linux-foundation.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 15:43:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 27 Oct 2014 14:09:38 -0700

> Perhaps sparc should be defining CONFIG_HAVE_GENERIC_RCU_GUP.
> 
> We really should switch x86 to the generic version - from a quick read
> it looks like it will work without needing any changes.
> 
> Steve, thoughts?

We need to add the necessary hooks to the generic code so that x86
doesn't so specualtive gets and instead do direct increments,
otherwise it's a performance regression, and then sparc can make use
of that as well.
