Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DBRYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:24:43 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:33839 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab3DBRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:24:42 -0400
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
Date: Tue, 2 Apr 2013 10:24:41 -0700
X-Google-Sender-Auth: cYFWEJjgdOu-zoIrS-nIAElBtJ0
Message-ID: <CA+55aFwbv=ghR+udRC-b+NAqETpkObsS48PU-44e5puji2oZgg@mail.gmail.com>
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
> If you guys are already looking at this, the conversions between size_t,
> long and int in the do_msgrcv/load_msg/alloc_msg code are a mess. You could
> trigger anything from:

Good catch.

Let's just change the "(long)bufsz < 0" into "bufsz > INT_MAX".

I suspect we should change some of the "int" arguments to "size_t" too
so that we don't have these kinds of odd "different routines see
different values due to subtle casting errors", but in the end we
don't really want to ever help people have these kinds of potential
overflow issues. We already limit normal read/write/sendmsg etc to
INT_MAX (although we tend to *truncate* it to INT_MAX rather than
return an error, but I think the simpler patch here is preferable
unless somebody complains).

Comments?

              Linus
