Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaI3AJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54125 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaI3AJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:29 -0400
Date: Tue, 30 Sep 2014 01:09:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Removing shared subtrees?
Message-ID: <20140930000924.GO7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:45:42PM -0700, Andy Lutomirski wrote:
> As far as I know, shared subtrees in recursive bind mounts are a
> misfeature that existed for the sole purpose of allowing recursive
> binds + chroot to emulate mount namespaces.

Wrong.  Different namespaces vs. multiple mounts in the same namespace
have nothing whatsoever with shared vs. slave.  It's completely orthogonal.

>  But we have mount
> namespaces, so what are they for?

???

> They're totally fsked up.  For example, don't try this on a live system:
> 
> # mount --make-rshared /
> # mount --rbind / /mnt
> # umount -l /mnt
> 
> It will unmount *everything*.

So will umount -l /

>  On Fedora, you don't even need the
> --make-rshared part.  WTF?

"Doctor, it hurts when I do it..."

I can suggest a few more self-LARTs, if you are interested...

> Can we just remove the feature entirely in linux-next and see if
> anyone complains?  I'm all for propagation across mount namespaces,
> but I suspect that, at the very least, there is no legitimate reason
> whatsoever for mounts to propagate from a recursive bind mount back to
> the origin.
> 
> IOW, can we kill shared mounts and just keep private and slave mounts?

What for?
