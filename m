Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3HSXt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:49:28 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36987 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3HSXt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:49:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9dFduWPr0n8c7ckZr=2AQ-h4sy4U9YYzTRw335Xaimc4tk-A@mail.gmail.com>
References: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
	<CAB9dFduWPr0n8c7ckZr=2AQ-h4sy4U9YYzTRw335Xaimc4tk-A@mail.gmail.com>
Date: Mon, 19 Aug 2013 16:49:26 -0700
X-Google-Sender-Auth: jSR8sO7w9htjt-Et4ntLkBIFJOE
Message-ID: <CA+55aFwqQBdYUU2MfccDpzc2S+oiP23QKdbPnfJsnVw1TR_H+Q@mail.gmail.com>
Subject: Re: [PATCH] proc: return on proc_readdir error
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:33 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
>
> By my reading that commit (f0c3b5093add) also made proc_readdir always
> return 0, so with this patch the effect I see is that no pid entries
> are listed under /proc, breaking ps for instance.  I don't see how
> even the previous version of proc_readdir could return a negative
> value; looks like 1 and 0 were the only possible return values.

Yes, see the other thread. The "return 1" case had gotten lost. I
think current git should get everything right, but please do test. I
did some testing of my own with a random little getdents test-program
(just checking that it got the same results with different (small)
buffer sizes), but it was by no means exhaustive.

              Linus
