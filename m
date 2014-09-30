Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaI3A3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:29:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54147 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3A3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:29:49 -0400
Date: Tue, 30 Sep 2014 01:29:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Removing shared subtrees?
Message-ID: <20140930002948.GP7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk>
 <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 05:14:55PM -0700, Andy Lutomirski wrote:
> I understand that:
> 
> # mount --make-rshared /
> # mount --rbind / /mnt
> # umount - /mnt/dev
> 
> should unmount /dev.  That's the whole point.  But why does unmounting
> */mnt* propagate like that?  It doesn't unmount /.  To me, this makes
> about as much sense as having 'umount -l /mnt/dev' unmount /dev/pts
> but *not* /dev would make.

Aha.  And what, pray tell, does umount -l /mnt do to mounts deeper in
the tree?  Forget about shared, etc. - what, in your opinion, does umount -l
mean wrt the stuff mounted on /mnt?  /mnt/dev, for example...

> > What for?
> 
> Simplicity and comprehensibility.

Such an elegant way to say "I can't be arsed to read"...  For what it's
worth: MNT_DETACH is *not* "detach the subtree as whole, busy or not".
It's "unmount all mounts within the subtree, busy or not".  At which point
the self-LART you keep describing becomes quite easy to comprehend, doesn't
it?
