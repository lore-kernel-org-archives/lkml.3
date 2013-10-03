Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3JCTGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:06:08 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:53938 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3JCTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <20131003174439.GG13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
	<CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
	<20131003105130.GE13318@ZenIV.linux.org.uk>
	<CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
	<20131003174439.GG13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 12:06:04 -0700
X-Google-Sender-Auth: t4nrcDBCt3UFHLSSV7R79gqLhCw
Message-ID: <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 10:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Anyway, I've done nicer variants of that protection for everything except
> fuse (hadn't gotten around to it yet); see vfs.git#experimental now:

Ok, I did a quick test, and it looks ok here, so looking good for 3.13.

However, the new smp_mb() in mntput_no_expire() is quite noticeable in
the path lookup stress-test profiles. And I'm not seeing what that
allegedly protects against, especially if mnt_ns is NULL (ie all the
common important cases).

            Linus
