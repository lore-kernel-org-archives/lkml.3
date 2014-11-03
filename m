Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaKCPnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:43:24 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:51198 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaKCPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141103152036.GA7996@ZenIV.linux.org.uk>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 07:42:58 -0800
Message-ID: <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Drysdale <drysdale@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>> Add a new O_BENEATH flag for openat(2) which restricts the
>> provided path, rejecting (with -EACCES) paths that are not beneath
>> the provided dfd.  In particular, reject:
>>  - paths that contain .. components
>>  - paths that begin with /
>>  - symlinks that have paths as above.
>
> Yecch...  The degree of usefulness aside (and I'm not convinced that it
> is non-zero),

This is extremely useful in conjunction with seccomp.

> WTF pass one bit out of nameidata->flags in a separate argument?
> Through the mutual recursion, no less...  And then you are not even attempting
> to detect symlinks that are not followed by interpretation of _any_ pathname.

How many symlinks like that are there?  Is there anything except
nd_jump_link users?  All of those are in /proc.  Arguably O_BENEATH
should prevent traversal of all of those links.

--Andy
