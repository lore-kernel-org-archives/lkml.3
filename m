Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaCWQp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:45:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57158 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaCWQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:45:27 -0400
Date: Sun, 23 Mar 2014 16:45:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs fixes
Message-ID: <20140323164526.GJ18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
 <CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 09:36:28AM -0700, Linus Torvalds wrote:
> On Sun, Mar 23, 2014 at 12:16 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Several fixes; first 4 commits are obvious fixes (a couple
> > of fdget_pos()-related ones from Eric Biggers, prepend_name() fix, missing
> > checks for false negatives from __lookup_mnt() in fs/namei.c)
> 
> I'm not seeing the obvious fix in the prepend_name() thing, and I
> think it's horrible to *update* the name-len to negative like it now
> does.
> 
> Why is anybody calling it with a negative buffer length in the first
> place? *That* is the bug. Making the buflen become negative just makes
> the bug worse, imnsho.

It's easier to skip checking the overflow on prepend() of "\0" in the
beginning of the whole thing and just let the next operation to fail.
That's where the corner case comes from.
