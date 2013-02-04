Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3BDFGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:06:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37447 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3BDFGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:06:02 -0500
Date: Mon, 4 Feb 2013 05:05:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H?vard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130204050550.GA4503@ZenIV.linux.org.uk>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
 <20130127195714.GA11224@samfundet.no>
 <20130127203009.GG4503@ZenIV.linux.org.uk>
 <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
 <20130204013111.GX4503@ZenIV.linux.org.uk>
 <20130204030221.GY4503@ZenIV.linux.org.uk>
 <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 08:52:18PM -0800, H?vard Skinnemoen wrote:

> You're right on -- in this case, the compiler will skip r10, and do
> (r12, r11, r8:r9, stack). We pass the syscall number in r8, but we
> also unconditionally move r7 to r8 in the syscall path, so it
> shouldn't matter (libc does the opposite when necessary).
> 
> I remember some talk about having the compiler reuse r10 for the next
> 32-bit argument in cases like this, but I don't think it ever
> happened.

Umm...  In case of fallocate() the next argument is 64bit one, though;
sys_fallocate() will be looking for two 32bit words on stack, so no
matter how do we pass them to syscall, we'd better push two words in
the wrapper.

But yes, 32bit/32bit/64bit/32bit is another interesting case -
fanotify_mark is 32/32/64/32/32.  From what ABI says it would seem to
be r12/r11/r8:r9/r10/stack, but if I understand you correctly, we'll
end up wanting *two* arguments on stack...
