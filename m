Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3C2TNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:13:12 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33483 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab3C2TNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130329190642.GC23893@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
	<20130329190642.GC23893@redhat.com>
Date: Fri, 29 Mar 2013 12:13:10 -0700
X-Google-Sender-Auth: AC0Kq99DzNO2RBJX5ABrNz9idC4
Message-ID: <CA+55aFwRvem_XDgEgU6Bd-Ztg7kp68G4kzuKFQVKN43UhipfLw@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:06 PM, Dave Jones <davej@redhat.com> wrote:
>
> Btw, something that's really bothering me is just how much bogus
> 'follow-on' spew we have lately. I'm not sure what changed, but it
> seems to have gotten worse.

.. we have many more sanity checks, and they tend to trigger in the
case of us killing somebody holding locks etc.

> Related: is there any value in printing out all the ? symbols on
> kernels with frame pointers enabled ?

I've found them useful. You can often see what happened just before.

Of course, I'd still prefer gcc not generate unnecessarily big stack
frames (which is one of the bigger reasons for old stuff shining
through) but as things are, they often give hints about what happened
just before.

          Linus
