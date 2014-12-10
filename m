Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaLJTuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:50:03 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39122 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbaLJTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <5488A203.7000600@linux.intel.com>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
	<CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
	<5488A203.7000600@linux.intel.com>
Date: Wed, 10 Dec 2014 11:49:58 -0800
X-Google-Sender-Auth: vn2dGeNbbicnpsPJ2-AmCZ5xVKA
Message-ID: <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
Subject: Re: [GIT pull] x86 mpx support for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:41 AM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
> But, this is the kind of option that we want to be *sure* is enabled
> unless folks know exactly what they are doing, so we should probably
> hide it behind CONFIG_EXPERT as well, just as SMEP is.

I disagree.

SMEP doesn't have any performance overhead, and SMEP is available in
processors available today. So SMEP doesn't even have a config option,
because there is no downside with having it on and enabled.

MPX, in contrast, you don't even normally want to run at all as a
normal user because of the overheads. That's going to be true even
when it's available.

So I would claim the exact reverse: right now, enabling MPX should be
something only experts should do.

                  Linus
