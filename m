Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaIYOb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:31:27 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:60854 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaIYObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:31:24 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140924190058.GE7996@ZenIV.linux.org.uk>
References: <20140924152523.GC7441@tucsk.piliscsaba.szeredi.hu>
	<20140924190058.GE7996@ZenIV.linux.org.uk>
Date: Thu, 25 Sep 2014 16:31:22 +0200
Message-ID: <CAJfpegtQJ1MRWe21PTjfpNh2OWEZdgFXuTGTOWQHGLyyk9eGpQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix linkat error for unprivileged AT_EMPTY_PATH
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Sep 24, 2014 at 05:25:23PM +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Return proper error value for linkat(..., AT_EMPTY_PATH) without enough
>> privileges.
>>
>> I guess ENOENT was used here, because without AT_EMPTY_PATH that's what
>> we'd return for an empty path.  But it is wrong for AT_EMPTY_PATH, since we
>> might not even be passing an empty path, we are simply complaining about
>> lack of privs for which EPERM is the proper error.
>
> Umm...  Are you sure that nothing in userland is checking for that
> return value?  I agree that EPERM would make more sense, but...

How could I be sure?

But does it even make sense to check for that error value?  I don't
think it is, since we have never allowed unprivileged AT_EMPTY_PATH
for linkat  (except by bb2314b4799649 which was reverted before being
included in a release).

So if when (if ever) we do allow that, *then* testing for an error
value will make sense.  But surely if one is writing code which can't
even be tested, then it won't come as a big surprise if it will
eventually fail...

Thanks,
Miklos
