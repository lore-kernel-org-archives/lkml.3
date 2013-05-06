Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab3EFWME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:12:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56707 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758319Ab3EFWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:12:01 -0400
Date: Mon, 6 May 2013 23:11:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matt Turner <mattst88@gmail.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] alpha: spinlock: don't perform memory access in locked
 critical section
Message-ID: <20130506221152.GA24639@mudshark.cambridge.arm.com>
References: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
 <CAEdQ38HnWbUB=ZNCZeYz8GZH3U4bv_Uag8WL2zT0D=GMcoT+2A@mail.gmail.com>
 <20130506205329.GO25399@ZenIV.linux.org.uk>
 <20130506211238.GA24282@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130506211238.GA24282@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 10:12:38PM +0100, Will Deacon wrote:
> The other (hopefully also wrong) worry that I had was when the manual
> states that:
> 
> `If the virtual and physical addresses for a LDx_L and STx_C sequence are
>  not within the same naturally aligned 16-byte sections of virtual and
>  physical memory, that sequence may always fail, or may succeed despite
>  another processor’s store to the lock range; hence, no useful program
>  should do this'
> 
> This seems like it might have a curious interaction with CoW paging if
> userspace is trying to use these instructions for a lock, since the
> physical address for the conditional store might differ from the one which
> was passed to the load due to CoW triggered by a different thread. Anyway,
> I was still thinking about that one and haven't got as far as TLB
> invalidation yet :)

In case anybody is interested, the software broadcasting of TLB maintenance
solves this problem because the PAL_rti on the ret_to_user path will clear
the lock flag.

Will
