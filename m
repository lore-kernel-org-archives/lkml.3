Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaIJSAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:00:14 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37524 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaIJSAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:00:11 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.149]
In-Reply-To: <1410365139-24440-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410365139-24440-1-git-send-email-linux@rasmusvillemoes.dk>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 10 Sep 2014 13:59:50 -0400
Message-ID: <CAOFdcFMwEbvRAheZ5RD20nU1GcaMJXy=o5=fsaiFudy+cyiZuQ@mail.gmail.com>
Subject: Re: [PATCH resend] Kbuild: x86: Eliminate duplicate command line options
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 12:05 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> The options -mno-mmx and -mno-sse are unconditionally added to
> KBUILD_CFLAGS in both branches of an ifeq and through a $(cc-option)
> further down. We can safely remove the first instances.
>
> In fact, since the -mno-mmx and -mno-sse options were introduced
> simultaneous with the other two options in the $(cc-option) [according
> to http://www.gnu.org/software/gcc/gcc-3.1/changes.html], and since
> the former were unconditionally used, one can deduce that only gcc
> versions knowing about all four are supported. So also eliminate the
> $(cc-option) wrap.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: Peter Foley <pefoley2@pefoley.com>
