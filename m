Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaGHQyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:54:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58195 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaGHQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140708120331.GA30459@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <20140708120331.GA30459@infradead.org>
From: David Drysdale <drysdale@google.com>
Date: Tue, 8 Jul 2014 17:54:24 +0100
Message-ID: <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
To: Christoph Hellwig <hch@infradead.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 1:03 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 11:28:01AM +0100, David Drysdale wrote:
>> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> provided path, rejecting (with -EACCES) paths that are not beneath
>> the provided dfd.  In particular, reject:
>>  - paths that contain .. components
>>  - paths that begin with /
>>  - symlinks that have paths as above.
>
>
> How is this implemented in FreeBSD?  I can't find any references to
> O_BENEATH_ONLY except for your patchset.

FreeBSD have the relative-only behaviour for openat() relative to a
Capsicum capability dfd [1], and for a process in capability-mode [2],
but they don't have the O_BENEATH_ONLY as a separately-accessible
openat() flag.  However, it seemed like a more widely useful idea so
separating it out was suggested.

[1] http://fxr.watson.org/fxr/source/kern/vfs_lookup.c?v=FREEBSD10#L238
[2] http://fxr.watson.org/fxr/source/kern/vfs_lookup.c?v=FREEBSD10#L171
