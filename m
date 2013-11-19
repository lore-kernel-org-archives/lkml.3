Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KSTiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:38:54 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51101 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3KSTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:38:51 -0500
MIME-Version: 1.0
In-Reply-To: <528AEB27.2070404@zytor.com>
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>
	<CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
	<528AEB27.2070404@zytor.com>
Date: Tue, 19 Nov 2013 11:38:50 -0800
X-Google-Sender-Auth: j-B_oXowf0pHQXJEJxaSHa8XRlE
Message-ID: <CA+55aFywiJf1TiSaXSZNkUpGpgtJa1pmZa7E+BOJafvTQCuzdA@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 8:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Do you have a preference:
>
> 1. Considering the 32-bit truncation incidental (take it or leave it);
> 2. Require the 32-bit truncation, or
> 3. Get rid of it completely?

I don't have a huge preference, but I hate the current situation (with
Fenghua's patch) where it's not consistent. One path uses just 32-bits
of the count (thanks to the "mov %edx,%ecx") while another path uses
64 bits.

One or the other, but not a mixture of both.

And only tangentially related to this: I do think that we could be
stricter about the count. Make it oops if the high bits are set,
rather than overwrite a lot of memory. So I would not be adverse to
limiting the count to 31 bits (or even less) explicitly, and thus
making the while 32-vs-64 bit issue moot.

             Linus
