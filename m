Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3DWRwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:52:36 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61122 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3DWRwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:52:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130423.133732.2222922370397287096.davem@davemloft.net>
References: <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
	<CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
	<20130423.133732.2222922370397287096.davem@davemloft.net>
Date: Tue, 23 Apr 2013 10:52:33 -0700
X-Google-Sender-Auth: pORGlCX3FGa5TQMHHga7QTYeoyE
Message-ID: <CA+55aFzVcptyMSDpFzE_-npbs-ycS+9z_nknoZm1+bQws1pWnA@mail.gmail.com>
Subject: Re: Unsigned widening casts of binary "not" operations..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: David Laight <David.Laight@aculab.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:37 AM, David Miller <davem@davemloft.net> wrote:
>
> I just want to mention that this is dangerous in different ways, we
> just recently got a patch in the networking that removed such a cast.
> The problem is when the cast narrows, f.e.:
>
>         ~(u8)0
>
> doesn't do what you think it does.  That doesn't evaluate to 0xff.

Yeah, sparse will get that right, but won't warn about it even with my
patch. The normal "all arithmetic is done in *at*least* 'int'" will
always kick any C expression like that up to 'int' before the binary
not op is done. So in your example, the implicit cast is widening the
value *before* the binary not, not after.

                     Linus
