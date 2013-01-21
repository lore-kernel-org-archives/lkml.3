Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3AUBkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:40:52 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:52085 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3AUBkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130121012217.GQ4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com> <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk> <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
 <20130121012217.GQ4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 17:40:28 -0800
X-Google-Sender-Auth: R93Ri6b567i4zSOzSz52BbsvAFw
Message-ID: <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 5:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Anyway, that's a separate story - semctl(2) is going to be ugly, no matter
> what we do, but the rest of those guys doesn't have to.  How about the
> following (completely untested):

Hmm.  Looks like the RightThing(tm) to me.

The thing that stands out that I question the value of that
HAVE_SYSCALL_WRAPPERS thing. Is there any reason we don't just make
all architectures use it? What's the downside? I'm not sure I see the
point of the non-wrapper version.

                  Linus
