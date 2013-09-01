Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab3IAP66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:58:58 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35494 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3IAP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <5223311D.2040608@zytor.com>
References: <5223311D.2040608@zytor.com>
Date: Sun, 1 Sep 2013 08:58:54 -0700
X-Google-Sender-Auth: JTZ2I9IgSgRinPsHnCJ5_qUG7B4
Message-ID: <CA+55aFwUKyJwphC7EFCgQKGLfZq1yrjx+4CrMhJeVmxFr8QNdg@mail.gmail.com>
Subject: Re: On the correctness of dbe3ed1c078c193be34326728d494c5c4bc115e2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 5:20 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> This has the end result that we treat a user space instruction which
> touches a privileged data structure that then page faults (e.g. a
> segment load which causes #PF on the GDT) as a user-space fault.
>
> This seems very wrong to me, since such a #PF would indicate a serious
> error in the kernel.

Not necessarily. Don't we basically do exactly that for the F00F bug
workaround, for example?

                Linus
