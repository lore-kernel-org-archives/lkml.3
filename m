Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaCCXyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:54:31 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:53335 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCCXy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140303233902.GP18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<CA+55aFxszctXek3QCXPeDScdSQZvuzp+EXHdA5cZnG3CLeJ1XA@mail.gmail.com>
	<CA+55aFwjSAPx=6x6r9hN_1hH406=TCnAyb=6s0BLt9=YsKy_wA@mail.gmail.com>
	<20140303233902.GP18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 15:54:29 -0800
X-Google-Sender-Auth: FI0alqE_1D9fBtZDWfi0KJGe__g
Message-ID: <CA+55aFwSr-CnqE6vxykhkNTo7BkFXGD6uGJC00A2vJd10HZxJA@mail.gmail.com>
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

On Mon, Mar 3, 2014 at 3:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> do_sendfile() is also there and this one is even more unpleasant ;-/
> We probably can ignore that one (until POSIX learns of its existence),
> thouhg...

Yeah, I saw the do_sendfile one and decided we don't care. Not only is
is out of POSIX spec (so if you break it you get to keep both pieces),
the whole sendfile() thing is a bit of a hack.

But we could take the f_pos_lock explicitly in do_sendfile for the
!ppos case if we decide we care. The error handling is the main
annoyance.

           Linus
