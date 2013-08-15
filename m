Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3HOFAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:00:04 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36622 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3HOFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:00:00 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <87a9kkax0j.fsf@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
Date: Thu, 15 Aug 2013 06:59:59 +0200
Message-ID: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
Subject: Re: DoS with unprivileged mounts
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 9:32 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:

>> The solution is also theoretically simple: mounts in unpriv namespaces
>> are marked "volatile" and are dissolved on an unlink type operation.
>>
>> Such volatile mounts would be useful in general too.
>
> Agreed.
>
> This is a problem that is a general pain with mount namespaces in
> general.
>
> I think the real technical hurdle is finding the mounts t in some random
> mount namespace.  Once we can do that relatively efficiently the rest
> becomes simple.

We already have a "struct mountpoint" hashed on the dentry.  Chaining
mounts on that mountpoint would be trivial.  And we need a
MNT_VOLATILE flag and that's it.  If we fear that traversing the list
of mounts on the dentry to check for non-volatile ones then we could
also add a separate volatile counter to struct mountpoint and a
matching flag to the dentry.  But I don't think that's really
necessary.

Thanks,
Miklos
