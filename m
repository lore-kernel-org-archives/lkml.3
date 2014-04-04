Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaDDUYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:24:06 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45934 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaDDUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <871txeifsv.fsf@x220.int.ebiederm.org>
References: <CAKgNAkjymzawYMKZGedK=fai55cwo4p=yeYe6GT8MdxWON__zw@mail.gmail.com>
	<871txeifsv.fsf@x220.int.ebiederm.org>
Date: Fri, 4 Apr 2014 22:24:02 +0200
Message-ID: <CANXojcx18esEq6CHjiqpiYCMh635cVsSqfmBnfZ=25ngztNHzw@mail.gmail.com>
Subject: Re: Things I wish I'd known about Inotify
From: Stef Bon <stefbon@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@redhat.com>,
        Lennart Poettering <lennart@poettering.net>, radu.voicilas@gmail.com,
        daniel@veillard.com, Christoph Hellwig <hch@infradead.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>, gamin-list@gnome.org,
        lkml <linux-kernel@vger.kernel.org>,
        inotify-tools-general@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-03 17:38 GMT+02:00 Eric W. Biederman <ebiederm@xmission.com>:

>
> Other pitfalls.
>
> Inotify only report events that a user space program triggers through
> the filesystem API.  Which means inotify is limited for remote
> filesystems

I'm working on enabling fsnotify for fuse. The sending of a watch/mask
to userspace works, and the fuse filesystem can forward the watch to
it's backend.
Reporting delete events back to the kernel works with the help of one
existing call fuse_lowlevel_notify_delete. There is no existing call
to report a create, so I'm working on that.

( at this moment I'm trying to enable the most simple events : delete
and create of an entry in a directory which is watched).

Stef Bon
