Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaCKBjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:39:06 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:62381 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaCKBjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
Date: Mon, 10 Mar 2014 18:39:03 -0700
X-Google-Sender-Auth: LbnQizz_UNoKp0kmS8nSj7IRhAI
Message-ID: <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 6:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> This is a bit of an abuse of the no-breaking-userspace policy.

No it's not, because it won't be applied.

You need to fix it.

I'm not sure what goes wrong, since it *looks* like you handle the
"vdso_enabled" thing correctly, so I find it surprising that you say
that

    echo 0 >/proc/sys/abi/vsyscall32

makes it work, since it should be zero already, and that echo should
be a no-op. But maybe I'm missing something.

Maybe you can just fake the boot parameter and fix the OpenSuSE
breakage that way (presumably that "init" sees it if it's some
user-space setup thing), but I'd like to know why that "echo 0" works,
but just initializing it to zero does not?

             Linus
