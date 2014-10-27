Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaJ0QC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:02:59 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:61858 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaJ0QCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <20141027092311.GA9807@amd>
References: <1413881397.30379.7.camel@hadess.net>
	<loom.20141021T140216-28@post.gmane.org>
	<20141027092311.GA9807@amd>
Date: Mon, 27 Oct 2014 20:02:51 +0400
X-Google-Sender-Auth: 1EMxSiJa5DHWztGdCqGXXuqx_uU
Message-ID: <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If "recursive mtime" was available, would that work for you?

It would work for detecting "offline" changes. I suppose recursive
mtime not viable for online monitoring, mostly because detecting file
renaming would be a massive PITA (and we already have fanotify with
exactly this problem).

Another approach to offline monitoring is using things like btrfs
changelogs - e.g. incremental "btrfs send", but I don't think that's
viable for other filesystems and I don't know how efficient it is even
on btrfs.

Actually, being able to read btrfs changelog from userspace more or
less as it happens (<200ms latency on commodity x86) would fulfill our
requirements for online VFS monitoring facility, and we could use
"btrfs send" approach for replaying offline changes. The good thing
about this approach is that it can use a fixed-size buffer for feeding
the info in userspace - if userspace can't keep up, the data is not
lost but recorded to the filesystem and can be retrieved from it
later. In this case we'd be tied to a specific filesystem, but that's
worlds better than nothing at all.

-- 
Sergey "Shnatsel" Davidoff
