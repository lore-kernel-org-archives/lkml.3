Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3EKTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 15:16:26 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:59995 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3EKTQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 15:16:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130511172242.GP25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
	<CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
	<20130511172242.GP25399@ZenIV.linux.org.uk>
Date: Sat, 11 May 2013 12:16:22 -0700
X-Google-Sender-Auth: -o5lij9GlMuk7lZQWi0GIGU-a5g
Message-ID: <CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
Subject: Re: [RFC] next cycle fun: ->release() API change
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 10:22 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Because renaming really doesn't buy us anything but pain.
>
> Umm...  I'd rather go the whole way and get rid of inode argument as well,
> while we are at it.  It's completely redundant and it's unused in very large
> majority of the instances.

So? What's the advantage of removing it?

Also, "->close()" would be *exactly* the wrong name to call this,
since it would be absolutely and utterly misleading. "->release()" is
_not_ about close, and in fact the whole return code is partially due
to people thinking it is. It's "->flush()" that gets called at close
time.

               Linus
