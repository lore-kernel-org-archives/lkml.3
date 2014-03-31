Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaCaTea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:34:30 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51161 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaCaTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140331144934.GA12335@gmail.com>
References: <20140331144934.GA12335@gmail.com>
Date: Mon, 31 Mar 2014 12:34:28 -0700
X-Google-Sender-Auth: NAURQS6DE8Fbr8fTrbDXTQjBA9k
Message-ID: <CA+55aFyAi0Vh6L5C8G6Jm3-FP81TNZekM_MiN-0wA3vvg3tSCQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/iommu change for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 7:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Neil Horman (1):
>       x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Before I pull this, I want somebody to double-check it:

> -       if (revision == 0x13)
> +       if (revision < 0x13)
>                 set_irq_remapping_broken();

This change does *not* match the comment just above it. The comment
talks very much about revision 13.

So the comment should be fixed, and/or that "< 0x13" should perhaps be
"<= 0x13".

Because making it "less than" simply makes no sense in light of the
comment. Does revision 13 suddenly work? Was that where it was fixed?
If so, please fix the comment.

                Linus
