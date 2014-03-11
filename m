Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaCKDJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:09:46 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61428 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaCKDJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:09:45 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
	<CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
	<CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
Date: Mon, 10 Mar 2014 20:09:40 -0700
X-Google-Sender-Auth: O1KkJn0J6pbhPLI6IQWgYIr_yl4
Message-ID: <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
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

On Mon, Mar 10, 2014 at 7:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> It does.  My patch breaks OpenSuSE 9 when
> CONFIG_ENABLE_VDSO32_BY_DEFAULT=y unless it's overridden by sysctl or
> boot option.

Oh, I missed that "when =y" part.

But why do we then want to have that "=y" as an option at all?

If the situation is that everybody is fine with that being disabled by
default, let's just make it the default. And I'd even be ok with
removing it as an option *entirely*.

That would seem to be *much* preferable that having an option that
nobody really wants anyway, and where the default value would break
some users. THAT just seems completely insane.

                   Linus
