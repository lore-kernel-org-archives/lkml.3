Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbaD2SRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:17:14 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50491 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612AbaD2SRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
	<CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
Date: Tue, 29 Apr 2014 11:17:12 -0700
X-Google-Sender-Auth: 1ibD8zTV7tMY4PGrfOzbuvOypZU
Message-ID: <CA+55aFz7CrYrwdNScC+5Y8CJ1PaWF7MbrOCRyd_zECt8PXbBqA@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 11:03 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Because we no longer have that.  It now uses the list_lru thing, with
> a "per-node" lock, whatever that one is.

Oh, yes. Right you are. I just started looking at that and went "ugh".

The lru lists are all distributed now with multiple locks (well, one
per list node).

> Another idea, which could have subtler effects, is simply not to kill
> a dentry that is on the shrink list (indicated by
> DCACHE_SHRINK_LIST), since it's bound to get killed anyway.  But
> that's a change in behaviour...

Ooh, I like the way you think. I don't see why this wouldn't be the
right approach.

            Linus
