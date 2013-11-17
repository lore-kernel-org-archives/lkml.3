Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3KQGwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 01:52:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3KQGwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 01:52:01 -0500
Message-ID: <5288677D.3040809@zytor.com>
Date: Sat, 16 Nov 2013 22:51:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Peter Anvin <hpa@linux.intel.com>, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, fenghua.yu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org> <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
In-Reply-To: <CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 10:44 PM, Linus Torvalds wrote:
> So this doesn't do the 32-bit truncation in the error path of the generic
> string copy. Oversight?
> 
>        Linus

Indeed... although in the kernel it seems to be taken as an invariant
that copy lengths over 4G is simply prohibited.  There are places all
over the kernel which will fail in a massive way if we ever ended up
with a copy over 4G in size.

As such, I would argue the code with the patch is actually no more
broken than with the truncation in place; if anything it is *more*
correct than the modified one, since for a (very small) subset of >=4G
copies it will actually do the right thing, albeit slowly.

The truncations do make me twitch a little inside, I have to admit.

	-hpa

