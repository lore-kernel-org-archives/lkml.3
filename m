Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaJYTDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:03:09 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:65339 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaJYTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141025091537.GA11433@gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
 <20141025091537.GA11433@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 25 Oct 2014 09:05:05 -0700
Message-ID: <CALCETrV6fFKx7F18ox8MkdezDittsmsaSZC4H9rc8LL3-myzgA@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 25, 2014 2:15 AM, "Ingo Molnar" <mingo@kernel.org> wrote:
>
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
> > Is there any good reason not to use vmalloc for x86_64 stacks?
>
> In addition to what hpa mentioned, __pa()/__va() on-kstack DMA
> gets tricky, for legacy drivers. (Not sure how many of these are
> left though.)

Hopefully very few.  DMA debugging warns if the driver uses the DMA
API, and if the driver doesn't, then IOMMUs will break it.

virtio-net is an oddball offender.  I have a patch.

--Andy

>
> Thanks,
>
>         Ingo
