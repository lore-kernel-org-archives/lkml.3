Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaE0R56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:57:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaE0R55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:57:57 -0400
Date: Tue, 27 May 2014 18:57:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: fix vmplice_to_user()
Message-ID: <20140527175755.GV18016@ZenIV.linux.org.uk>
References: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzY--F_2BiZ4-mkFh+0Oy1SX7nBw7cAsSni_iDOtwU-mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzY--F_2BiZ4-mkFh+0Oy1SX7nBw7cAsSni_iDOtwU-mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:04:58AM -0700, Linus Torvalds wrote:
> On Tue, May 27, 2014 at 7:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > This patch fixes two bugs:
> 
> Mind if I change it to avoid the "goto"? I don't think goto is evil,
> but in this case it doesn't seem to buy anything, except to perhaps
> make the patch a bit smaller at the expense of making the result a bit
> harder to read.
> 
> Replacing the
> 
>    if (ret <= 0)
>       goto out;
> 
> with
> 
>    if (ret > 0) {
>        ...
>    }
> 
> also allows moving the various variable declarations closer to their use.
> 
> So something like the attached..

I'm not sure it's better; I've a pending patch that does combination of
rw_copy_check_uvector() with iov_iter_init(), which means that iov
array will be going to the outer scope anyway...
