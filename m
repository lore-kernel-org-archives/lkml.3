Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaCDAmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:42:39 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:45095 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCDAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:42:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140304002342.GS18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<20140303220106.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
	<20140303232858.GO18016@ZenIV.linux.org.uk>
	<CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
	<20140303234207.GQ18016@ZenIV.linux.org.uk>
	<CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
	<20140304002342.GS18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 16:42:36 -0800
X-Google-Sender-Auth: FDzJzhLs1i4tJARb5FJHtFVRF4c
Message-ID: <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
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

On Mon, Mar 3, 2014 at 4:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I wonder if something like
>
> static inline struct fd fdget(int fd)
> {
>         unsigned long v = __fdget(fd);
>         return (struct fd){(struct file *)(v & ~1), v & 1};
> }

Make it use "&3" so that we have the two bits we need, and I'll
happily take that approach, yes.

                    Linus
