Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3CWSAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:00:13 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3CWSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:00:12 -0400
Date: Sat, 23 Mar 2013 19:00:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC: Kernel lock elision for TSX
Message-ID: <20130323180010.GK20853@two.firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <CA+55aFyWMqwBfd6aYfRaLpX6gGqNxEkD5TFM3HRQpi9nAhn+0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyWMqwBfd6aYfRaLpX6gGqNxEkD5TFM3HRQpi9nAhn+0g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linux,

Thanks.  Other code/design review would be still appreciated, even
under the current constraints.

> The other comment I have is that since it does touch non-x86 header
> files etc (although not a lot), you really need to talk to the POWER8
> people about naming of the thing. Calling it <linux/rtm.h> and having
> "generic" helpers called _xtest() used by the generic spinlock code
> sounds a bit suspect.

I can make up another name for _xtest()/_xabort() and linux/rtm.h,
(any suggestions?)

The basic concepts implemented there should be pretty universal.
If others have a equivalent of "is this a transaction" and "abort
this tranction" they can just plug it in. Otherwise they will nop it,
as it's only hints anyways.

The only things used outside x86 code is _xtest()/_xabort(), can
remove the rest from linux/*. Without transactions this is all nops.
The primary interface for the lock code is the much higher level
elide()/elide_lock_adapt() interface anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
