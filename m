Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaD2XIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:08:12 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:63099 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaD2XIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140429230624.GA28966@thunk.org>
References: <535FADDA.2070803@1h.com> <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail> <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail> <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail> <53602B84.1020304@mit.edu> <20140429230624.GA28966@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Apr 2014 16:07:50 -0700
Message-ID: <CALCETrVgxfNgNuh62non-sB=JTxGN-vSoj-nyRytzgb54WO9EQ@mail.gmail.com>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 4:06 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 29, 2014 at 03:45:24PM -0700, Andy Lutomirski wrote:
>>
>> Wait, what?
>>
>> Inodes aren't owned by user namespaces; they're owned by users.  And any
>> user can arrange to have a user namespace in which they pass an
>> inode_capable check on any inode that they own.
>>
>> Presumably there's a reason that CAP_SYS_IMMUTABLE is needed.  If this
>> gets merged, then it would be better to just drop CAP_SYS_IMMUTABLE
>> entirely.
>>
>> Nacked-by: Andy Lutomirski <luto@amacapital.net>
>
> Right, but you can't set a mapping in a child namespace unless you
> have CAP_SETUID in the parent namespace, right?

Nope.  You can't set a mapping for someone else's uid, but you can
certainly map your own.

> Otherwise user
> namespaces are completely broken from a security perspective, since
> inode_capable() could never do the right thing.

I don't know what inode_capable's "right thing" is, but at least one
of the existing callers is blatantly wrong.  Patches coming shortly.

>
> Personally, reading how user namespaces work, it makes the hair rise
> on the back of my neck.  I'm not sure the concept works at all from a
> security perspective, but hey, I'm not using user namespaces, and some
> fool thought it was worth merging.  :-)

I like them.  I've also found quite a few serious bugs in them.  So go figure :)

--Andy
