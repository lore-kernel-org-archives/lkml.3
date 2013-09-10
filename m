Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3IJBeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:34:20 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:56732 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3IJBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk>
	<20130910004020.29299.qmail@science.horizon.com>
	<20130910005754.GV13318@ZenIV.linux.org.uk>
	<CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
Date: Mon, 9 Sep 2013 18:34:16 -0700
X-Google-Sender-Auth: wS5iekkgybwVcA33hD_WE92xFMw
Message-ID: <CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, George Spelvin <linux@horizon.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        John Stoffel <john@stoffel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 6:15 PM, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
>
> Maybe it should then?

It doesn't need to. The RCU lookup looks at individual dentry sequence
numbers and doesn't care about the bigger rename sequence number at
all.

The fallback (if you hit one of the very very rare races, or if you
hit a symlink) ends up doing per-path-component lookups under the
rename sequence lock, but for it, read-locking it until it succeeds is
the right thing to do.

              Linus
