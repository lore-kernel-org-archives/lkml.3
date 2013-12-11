Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LKCgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:36:13 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54608 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3LKCgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:36:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131209233002.GV31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209233002.GV31386@dastard>
Date: Tue, 10 Dec 2013 18:36:11 -0800
Message-ID: <CAGXu5j+u0xSN7jQk8udLefMAa5xNSNHU98as33QYHWOyv-JuJw@mail.gmail.com>
Subject: Re: XFS security fix never sent to -stable?
From: Kees Cook <keescook@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 3:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> [CC the xfs list. Kees - I shouldn't have to remind you to do this. ]
>
> On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> Hi,
>>
>> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> capability check to free eofblocks ioctl") is a security fix that was
>> never sent to -stable? From what I can see, it was introduced in 3.8
>> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> XFS_IOC_FREE_EOFBLOCKS ioctl").
>>
>> I don't see this in the 3.8.y tree. Should it be added there and newer?
>
> Well, it's not really a security problem at all, given that it only
> affects speculative preallocation beyond EOF. i.e. it affects
> filesystem metadata that does not yet index any user data.
>
> Indeed, the kernel already does exactly what this ioctl does every 5
> minutes without user intervention. i.e. it's simply a maintenance
> task we need to execute periodically or on demand as a result of
> other events (e.g. from a userspace daemon that is listen to quota
> exhaustion messages).
>
> So apart from allowing a user to burn some CPU with the ioctl doing
> nothing but scanning, there's little in way of a security problem
> being exposed on kernels prior to 3.12 here.
>
> The reason for the cap check? Turning off this ioctl in containers
> restricted by user name spaces. i.e. new functionality added to XFS
> in 3.12 introduced curiously vague and difficult to explain new
> inode access restrictions, so we took the "be safe by default" route
> and only allowed the init namespace access to the ioctl....

Right, it wasn't clear from the commit, and it looked troublesome, but
it's function wasn't obvious, so that's why I asked.

-Kees

-- 
Kees Cook
Chrome OS Security
