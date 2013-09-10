Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3IJDNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:13:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46878 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab3IJDNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk> <20130910004020.29299.qmail@science.horizon.com>
 <20130910005754.GV13318@ZenIV.linux.org.uk> <CALkWK0mMvaFcO7dXNbFxcP-42HxXs=s-v9HAR6zg369-ysJNMA@mail.gmail.com>
 <CA+55aFw8aHnDgj1WBhPGMpi9ZHaNpa2roDW5wuxF1Xab49QTew@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 10 Sep 2013 08:42:57 +0530
Message-ID: <CALkWK0ko21Xx9Dtbtk8FYvYxy6TWM8ncmO5MQ1A0L4HMCsPadw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
To: Linus Torvalds <torvalds@linux-foundation.org>
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

Linus Torvalds wrote:
> It doesn't need to. The RCU lookup looks at individual dentry sequence
> numbers and doesn't care about the bigger rename sequence number at
> all.

Right; it's sequential.

> The fallback (if you hit one of the very very rare races, or if you
> hit a symlink) ends up doing per-path-component lookups under the
> rename sequence lock, but for it, read-locking it until it succeeds is
> the right thing to do.

No, it's write-locking.
