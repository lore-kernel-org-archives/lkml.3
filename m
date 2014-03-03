Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaCCX7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:59:39 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43683 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaCCX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:59:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140303234207.GQ18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<20140303220106.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
	<20140303232858.GO18016@ZenIV.linux.org.uk>
	<CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
	<20140303234207.GQ18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 15:59:36 -0800
X-Google-Sender-Auth: W4Y3QrnkFpORW_SybLjo0G7wRxg
Message-ID: <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 3:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 03, 2014 at 03:34:43PM -0800, Linus Torvalds wrote:
>>
>> (Side note: I think sparc or something doesn't support it, and may
>> return things in memory. I can't really seem to find it in myself to
>> care)
>
> sparc64 actually does support that.  So does amd64, and, with explicit
> flag, i386.  No other more or less general purpose architecture does.
>
> Not ppc.  Not mips.  Not arm.  I think that some of those are worth
> caring about...

I doubt it's worth caring about. Even when passing things in memory,
the end result isn't that much worse than the fget_light() model that
passes just one of the two fields in memory.

If the ARM/PPC people end up caring, they could add the struct-return
support to gcc. It should be basically just adding the flag for
enabling the calling convention - the core gcc support is obviously
all there, and it's just an issue of whether the calling conventions
allow it or not.

             Linus
