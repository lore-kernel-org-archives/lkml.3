Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3HNUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:25:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49481 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab3HNUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <8761v882wj.fsf@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <520BD9E0.8050304@mit.edu> <8761v882wj.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Aug 2013 13:25:34 -0700
Message-ID: <CALCETrWnNfQnOKjfXx8hwsVzPfcoUseuY5JD1X7fRSPXOj61MA@mail.gmail.com>
Subject: Re: DoS with unprivileged mounts
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:53 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On 08/14/2013 10:42 AM, Miklos Szeredi wrote:
>>> There's a simple and effective way to prevent unlink(2) and rename(2)
>>> from operating on any file or directory by simply mounting something
>>> on it.  In any mount instance in any namespace.
>>>
>>> Was this considered in the unprivileged mount design?
>>>
>>> The solution is also theoretically simple: mounts in unpriv namespaces
>>> are marked "volatile" and are dissolved on an unlink type operation.
>>
>> I'd actually prefer the reverse: unprivileged mounts don't prevent
>> unlink and rename.  If the dentry goes away, then the mount could still
>> exist, sans underlying file.  (This is already supported on network
>> filesystems.)
>
> Of course we do this in network filesystems by pretending the
> rename/unlink did not actually happen.  The vfs insists that it be lied
> to instead of mirroring what actually happened.
>
> Again all of this is a question about efficient data structures and not
> really one of semantics.  Can either semantic be implemented in such a
> way that it does not slow down the vfs?

Given that vfs_unlink has:

	if (d_mountpoint(dentry))
		error = -EBUSY;

I think it's just a matter of changing / deleting that code.

--Andy
