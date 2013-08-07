Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3HGT0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:26:19 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:40241 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3HGT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:26:17 -0400
MIME-Version: 1.0
In-Reply-To: <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130806154314.GA398@redhat.com>
	<CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
Date: Wed, 7 Aug 2013 12:26:16 -0700
X-Google-Sender-Auth: 58DzAWWpO8j2QLDVLYdFQ80CJIY
Message-ID: <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 5:05 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>
> Personally I'd say the kernel should not limit what's written to debug
> registers. Why can't I write insane values to registers in _my_
> hardware? It's not like it's going to break the hardware or anything.

It may be your hardware, but do you know what might be running on it?
It's a security issue: setting debug traps on kernel code/data
addresses can not only leak information, it can cause serious trouble
(taking a debug trap on the first instruction of an NMI handler etc)
including kernel stack corruption...

You do want the kernel to give you file permission checking even
though it's "your machine", don't you? Very similar thing.

The fact that windows allows it is kind of irrelevant. They aren't
exactly known for caring deeply.

               Linus
