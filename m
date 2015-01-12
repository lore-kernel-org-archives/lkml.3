Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbbALGYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 01:24:11 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62904 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbALGYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 01:24:06 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXsSTPi2jmMgA_Muh6y6eU2yq-fs8_MGPhJVNnfYaop1A@mail.gmail.com>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com> <CALCETrXsSTPi2jmMgA_Muh6y6eU2yq-fs8_MGPhJVNnfYaop1A@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 12 Jan 2015 07:23:44 +0100
Message-ID: <CAK1hOcMj6S+fzECOOp7jS47fRecjXXLkaQ=yQMHHwvfX7vhY6Q@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 1:38 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Sequences
>>         pushl_cfi %reg
>>         CFI_REL_OFFSET reg, 0
>> and
>>         popl_cfi %reg
>>         CFI_RESTORE reg
>> happen quite often. This patch adds macros which generate them.
>>
>> No assembly changes (verified with objdump -dr vmlinux.o).
>
> Looks sane to me.  Where does this apply in relation to the rest of your series?

On top of my latest four-patch set.
