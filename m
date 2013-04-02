Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191Ab3DBRwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:52:17 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:47422 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab3DBRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <515B026B.1040901@oracle.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
	<20130329190642.GC23893@redhat.com>
	<CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com>
	<1364585774.31320.9.camel@thor.lan>
	<515B026B.1040901@oracle.com>
Date: Tue, 2 Apr 2013 10:52:15 -0700
X-Google-Sender-Auth: 21PLgDKL9FCTg2AwB49YlUX5pmc
Message-ID: <CA+55aFz-0J3uhJC-00AJ0R-4TVOYqFGJk0h5x0HmaX+JR6_MYQ@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 9:08 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> By just playing with the 'msgsz' parameter with MSG_COPY set.

Hmm. Looking closer, I suspect you're testing without commit
88b9e456b164 ("ipc: don't allocate a copy larger than max"). That
should limit the size passed in to prepare_copy -> load_copy to
msg_ctlmax.

Now, I think it's possibly still a good idea to limit bufsz to INT_MAX
regardless, but as far as I can see that prepare_copy -> load_copy
path is the only place that can get confused. Everybody else uses
size_t (or "long" in the case of r_maxsize) as far as I can tell.

        Linus
