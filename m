Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaI3APS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:15:18 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50240 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaI3APQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140930000924.GO7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 17:14:55 -0700
Message-ID: <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
Subject: Re: Removing shared subtrees?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 29, 2014 at 04:45:42PM -0700, Andy Lutomirski wrote:
>> As far as I know, shared subtrees in recursive bind mounts are a
>> misfeature that existed for the sole purpose of allowing recursive
>> binds + chroot to emulate mount namespaces.
>
> Wrong.  Different namespaces vs. multiple mounts in the same namespace
> have nothing whatsoever with shared vs. slave.  It's completely orthogonal.
>
>>  But we have mount
>> namespaces, so what are they for?
>
> ???

No, really, what is this VFS feature for?  It's a complicated,
confusing chunk of code.  Why is it there?

>
>> They're totally fsked up.  For example, don't try this on a live system:
>>
>> # mount --make-rshared /
>> # mount --rbind / /mnt
>> # umount -l /mnt
>>
>> It will unmount *everything*.
>
> So will umount -l /
>
>>  On Fedora, you don't even need the
>> --make-rshared part.  WTF?
>
> "Doctor, it hurts when I do it..."

I understand that:

# mount --make-rshared /
# mount --rbind / /mnt
# umount - /mnt/dev

should unmount /dev.  That's the whole point.  But why does unmounting
*/mnt* propagate like that?  It doesn't unmount /.  To me, this makes
about as much sense as having 'umount -l /mnt/dev' unmount /dev/pts
but *not* /dev would make.

>
> I can suggest a few more self-LARTs, if you are interested...
>
>> Can we just remove the feature entirely in linux-next and see if
>> anyone complains?  I'm all for propagation across mount namespaces,
>> but I suspect that, at the very least, there is no legitimate reason
>> whatsoever for mounts to propagate from a recursive bind mount back to
>> the origin.
>>
>> IOW, can we kill shared mounts and just keep private and slave mounts?
>
> What for?

Simplicity and comprehensibility.

--Andy
