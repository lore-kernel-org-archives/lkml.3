Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3GMDI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 23:08:57 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59030 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab3GMDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 23:08:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130712074558.GP18798@sgi.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
	<1373594635-131067-3-git-send-email-holt@sgi.com>
	<20130712074558.GP18798@sgi.com>
Date: Fri, 12 Jul 2013 20:08:56 -0700
X-Google-Sender-Auth: PxdDMSeY6XHJZt9t1MfZIWiVD4A
Message-ID: <CAE9FiQVYApvncM0gKZYoJ9LE0636rhCD70qGJe0ksxeXQ68jWw@mail.gmail.com>
Subject: Re: [RFC 2/4] Have __free_pages_memory() free in larger chunks.
From: Yinghai Lu <yinghai@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:45 AM, Robin Holt <holt@sgi.com> wrote:

> At the very least, I think we could change to:
> static void __init __free_pages_memory(unsigned long start, unsigned long end)
> {
>         int order;
>
>         while (start < end) {
>                 order = ffs(start);
>
>                 while (start + (1UL << order) > end)
>                         order--;
>
>                 __free_pages_bootmem(start, order);
>
>                 start += (1UL << order);
>         }
> }

should work, but need to make sure order < MAX_ORDER.

Yinghai
