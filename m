Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaI3Agv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:36:51 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:39801 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaI3Agt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140930002948.GP7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk> <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
 <20140930002948.GP7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 17:36:27 -0700
Message-ID: <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
Subject: Re: Removing shared subtrees?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 5:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 29, 2014 at 05:14:55PM -0700, Andy Lutomirski wrote:
>> I understand that:
>>
>> # mount --make-rshared /
>> # mount --rbind / /mnt
>> # umount - /mnt/dev
>>
>> should unmount /dev.  That's the whole point.  But why does unmounting
>> */mnt* propagate like that?  It doesn't unmount /.  To me, this makes
>> about as much sense as having 'umount -l /mnt/dev' unmount /dev/pts
>> but *not* /dev would make.
>
> Aha.  And what, pray tell, does umount -l /mnt do to mounts deeper in
> the tree?  Forget about shared, etc. - what, in your opinion, does umount -l
> mean wrt the stuff mounted on /mnt?  /mnt/dev, for example...

Ideally it would leave them around until the whole subtree had no
references, at which point /mnt and everything under it would
disappear with no side effects, because it has no references.

I suspect it detaches them immediately, especially after reading the
rest of your email.

>
>> > What for?
>>
>> Simplicity and comprehensibility.
>
> Such an elegant way to say "I can't be arsed to read"...  For what it's
> worth: MNT_DETACH is *not* "detach the subtree as whole, busy or not".
> It's "unmount all mounts within the subtree, busy or not".  At which point
> the self-LART you keep describing becomes quite easy to comprehend, doesn't
> it?

Again, *I have no problem with the current semantics of umount -l*,
except insofar as they interact really nastily with shared subtrees.
I have a problem with bidirectional shared subtrees *in general*.

--Andy
