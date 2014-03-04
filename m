Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaCDVR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:17:57 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48021 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbaCDVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140304200027.GA11932@ZenIV.linux.org.uk>
References: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<20140303220106.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
	<20140303232858.GO18016@ZenIV.linux.org.uk>
	<CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
	<20140303234207.GQ18016@ZenIV.linux.org.uk>
	<CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
	<20140304002342.GS18016@ZenIV.linux.org.uk>
	<CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
	<20140304010517.GT18016@ZenIV.linux.org.uk>
	<20140304200027.GA11932@ZenIV.linux.org.uk>
Date: Tue, 4 Mar 2014 13:17:50 -0800
X-Google-Sender-Auth: aNcC1BB_HxEbhBowTDCd340YK28
Message-ID: <CA+55aFy2G5e0oBNWwmEiA5VS9+bB37JRNV2=X161FKEeH_odwA@mail.gmail.com>
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

On Tue, Mar 4, 2014 at 12:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, with the attached set (the first one is essentially unchanged from
> your first one), it seems to work and produce better code on all targets
> I've tried.  Comments?

I'm certainly ok with it. You seem to have left the fput_light()
function around, though, despite removing fget_[raw_]light(). That
seems a bit silly, since there is no valid use any more apart from
net/socket.c that now doesn't balance things properly.

> I've also pushed those (on top of old ocfs2 fix) into vfs.git#for-linus,
> if you prefer to read it that way.  Should propagate in a few...

Should I pull?

I also get the feeling that the first patch should likely be marked
for stable. Hmm?

             Linus
