Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3CFQBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:01:42 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:65299 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3CFQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:01:40 -0500
MIME-Version: 1.0
In-Reply-To: <1362554012.7242.9.camel@buesod1.americas.hpqcorp.net>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFx5pAsC9Ej2h9mniEU89oD=1mq6iPA+R2MBX-z74J0B5Q@mail.gmail.com>
	<1362554012.7242.9.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 6 Mar 2013 08:01:39 -0800
X-Google-Sender-Auth: gUDJA_amp5CMS0hl60aKqeNsru4
Message-ID: <CA+55aFw7j1qLeNxhjfDqc1_MVHkr0m=VPGE+Lx5AmCBwxf8xyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 11:13 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> Digging into the _raw_spin_lock call:
>
>  17.86%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock
>                      |
>                      --- _raw_spin_lock
>                         |
>                         |--49.55%-- sys_semtimedop
>                         |          |
>                         |          |--77.41%-- system_call
>                         |          |          semtimedop
>                         |          |          skgpwwait
>                         |          |          ksliwat
>                         |          |          kslwaitctx

Hmm. It looks like you cut that off a bit too early. This shows that
half the cases came from sys_semtimedop. Where did the other half come
from?

             Linus
