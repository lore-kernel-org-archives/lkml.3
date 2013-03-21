Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3CUUcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:32:47 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:45015 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3CUUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130321202635.GA16406@redhat.com>
References: <20130321190653.GA15479@redhat.com>
	<20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
Date: Thu, 21 Mar 2013 13:32:45 -0700
X-Google-Sender-Auth: olPwuMwXxsYkgsUYy0IqCsjomzI
Message-ID: <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 1:26 PM, Dave Jones <davej@redhat.com> wrote:
>
> those are qstr's, so I used d_name.name, right ?

Yup. And if you want to, you could do p1->d_parent->d_name.name too,
just to make things obvious. It's technically racy, but by the time
the bug happens, who cares?

> I'd be surprised actually, I've got sysfs excluded from its list of victim files,
> due to unrelated issues still unresolved.  So unless it followed a symlink into
> sys from somewhere in /proc or /dev...
>
> It took a few hours to reproduce last time, I'll increase the number of child
> processes to see if I can trigger it faster now that I have the debug stuff in there.

Hmm, ok. Do you have any network mounts or fuse or other "odd"
filesystems etc? The whole "aliased inodes" thing might come from
something like that.

        Linus
