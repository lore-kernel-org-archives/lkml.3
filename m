Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaEFUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:00:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaEFUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:00:48 -0400
Date: Tue, 6 May 2014 22:00:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: A reduced Linux network stack for small systems
Message-ID: <20140506200047.GB5619@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <CAFLxGvww8t-PpuS3B=dFvn8k3xBydk3CgA=qoLyEbkKJZJ0xhQ@mail.gmail.com>
 <1399383246.8767.99.camel@empanada>
 <CAADnVQLYiNfXRrXc=VZkGEFDbNhF63AzPg6Gyu6P1SF=6AiO7g@mail.gmail.com>
 <1399390490.8767.122.camel@empanada>
 <CAADnVQ+nCtshedoDWN+QgiKzsCzBcojZOzrhkfzsqyXTpi4L=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+nCtshedoDWN+QgiKzsCzBcojZOzrhkfzsqyXTpi4L=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not quite. I'm saying: no extra optimizations, no GCC changes.
> Compile kernel as-is. Most functions have a stub for mcount() already.
> Use it to track whether kernel function was called or not.
> Collect this data in userspace (as perf already does), add few
> more functions that had 'notrace' attribute on them, and feed this into
> special linker that unpacks existing vmlinux, throws away cold functions,
> relocates the rest and here you have tiny vmlinux without recompilation.

That's very difficult for networking code. How would you know you 
exercised all the corner cases in the TCP stack? And you wouldn't
want a remotely exploitable system because some important error
handler is missing.

I agree it may work for some other subsystems.

-Andi
