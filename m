Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab3CVBXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:23:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61246 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3CVBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <1363914773.31240.58.camel@buesod1.americas.hpqcorp.net>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<1363914773.31240.58.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 21 Mar 2013 18:23:37 -0700
X-Google-Sender-Auth: HnhnmWW4CM_bHId5PCy1eI8_BPY
Message-ID: <CA+55aFz_J6UStcP0Xgnb1j4gRb=X4ogq44xDam3ySxWSrdHT4Q@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 6:12 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> ipc lock contention:
> 100 users:  8,74%  (vanilla)    3.17% (v3 patchset)
> 400 users:  21,86% (vanilla)    5.23% (v3 patchset)
> 800 users   84,35% (vanilla)    7.39% (v3 patchset)

Ok, I'd call that pretty much "solved". Sure, it's still visible, but
for being a benchmark that apparently does little else than pound on
those sysv semaphores, I think we can consider it pretty much fine.
I'm going to assume that anybody who actually then does any real work
(ie a database) is never going to see even close to this bad
contention.

Good job, Rik. I'm assuming we'll be merging this during the 3.10
merge window, and hopefully the merge conflicts will be sorted out
too. Rik, Peter, can you look at each others patches and see if you
can get that sorted out for Andrew?

            Linus
