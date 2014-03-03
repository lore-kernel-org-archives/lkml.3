Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaCCXeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:34:46 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:49739 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaCCXeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140303232858.GO18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<20140303220106.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
	<20140303232858.GO18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 15:34:43 -0800
X-Google-Sender-Auth: pVhcU1aG4fnaxuDRBCwncqDNg60
Message-ID: <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
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

On Mon, Mar 3, 2014 at 3:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...   I would be very surprised if that worked well.  You have just
> forced fdget() to comply to the ABI.  And unless that has such structs
> returned in register pairs, there's no way for compiler to do about
> that.

Register pairs are very much a common return model.

And we've relied on that before. For example, 64-bit pte's on x86-32
very much does that whole thing with the "pte_t" union.

So you can now commence being surprised.

(Side note: I think sparc or something doesn't support it, and may
return things in memory. I can't really seem to find it in myself to
care)

              Linus
