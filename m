Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3BZXn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:43:58 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48226 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3BZXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
References: <20130226045424.GA3576@osiris>
	<CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
	<20130226125739.GA3924@osiris>
	<CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
	<CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
Date: Tue, 26 Feb 2013 15:43:55 -0800
X-Google-Sender-Auth: fHvRruFwkn_egzFB7infMdl8WGs
Message-ID: <CA+55aFzckUoJGEywgentKT-vQieiuLu-mQtELiA6UotWqBWH7A@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 8:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It is totally untested, though.  Does it work for you (and we should
> do the same thing for the grows-up case, obviously)?

Ok, thinking about this more, this is not good enough.

There is one case where growing into the previous/next vma is
perfectly ok: when the previous/next vma is the same stack vma, and
the reason we expanded it was because we had somehow unmapped the
stack in the middle.

Which isn't common or normal, but it has been known to happen. People
doing things like unmapping sensitive data in the middle of the stack
or whatever. We explicitly allow that case for the stack guard page
for that reason.

So I'll need to extend on that logic a bit more.

                    Linus
