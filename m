Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaEAC7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:59:45 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:63158 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaEAC7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140501025105.GY18016@ZenIV.linux.org.uk>
References: <20140430195918.GS18016@ZenIV.linux.org.uk>
	<CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
	<20140430203823.GT18016@ZenIV.linux.org.uk>
	<CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
	<20140430211206.GU18016@ZenIV.linux.org.uk>
	<20140430221238.GV18016@ZenIV.linux.org.uk>
	<CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
	<CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
	<20140430234341.GX18016@ZenIV.linux.org.uk>
	<CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
	<20140501025105.GY18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 19:59:43 -0700
X-Google-Sender-Auth: _mCp4G6Uli0Qlsa8SfGz2LQPhAk
Message-ID: <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 7:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>       Help with profiling is needed; the loads to watch are
> the ones where dentry_kill() + dentry_free() are sufficiently high in profiles
> for the differences to matter.  Any takers?

I really hope there are no such loads, my "lock/unlock pairing"
suggestion was mostly so that the pairing is clearer, not necessarily
for performance.

That said, I'd assume that it migth be worth testing at least the
"lots of concurrent lookups of 'simple_dentry_operations' dentries".
So most of /proc, most uses of simple_lookup(). That at least triggers
the dentry_kill() path in dput(), so it should be fairly easy to get
profiles.

But real loads with real filesystems? That sounds harder.

              Linus
