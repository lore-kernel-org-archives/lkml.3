Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab3GZXso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:48:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:51876 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3GZXsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:48:43 -0400
Message-ID: <1374882473.9200.33.camel@pasglop>
Subject: Re: [GIT PULL] arm64 fixes for 3.11
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 27 Jul 2013 09:47:53 +1000
In-Reply-To: <CA+55aFzmEhGvqY883Bg568Gguewy41X9n1qDeaHkW2We6VVhZg@mail.gmail.com>
References: <20130726155458.GA31613@arm.com>
	 <CA+55aFzmEhGvqY883Bg568Gguewy41X9n1qDeaHkW2We6VVhZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 12:54 -0700, Linus Torvalds wrote:
> 
> *Some* other 64-bit architectures do 16k stack sizes. But neither
> x86-64 nor powerpc do, afaik. Instead, they do irq stacks, which is
> generally a better idea than having one big stack.

Sadly you over estimated us here :-) We do 16K *and* irq stacks on
64-bit ... Remember our ABI with it's 112 bytes minimum per frame ?

It's been a while since I've last audited our actual usage mind you, we
*might* be able to reduce it but at this stage, since our typical
configs use a 64K base page size, it's not a big deal (ie, it's not an
order-N allocation).

Cheers,
Ben.


