Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965567Ab3DPWig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:38:36 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37061 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965524Ab3DPWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <516DCEF3.6030803@zytor.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-5-git-send-email-keescook@chromium.org>
	<516DCEF3.6030803@zytor.com>
Date: Tue, 16 Apr 2013 15:38:34 -0700
X-Google-Sender-Auth: gLHlOroM1ObFz8kjiUrt9Bui8zM
Message-ID: <CAGXu5jJ8Gbuj6=ebzu7Wwx2MRD-7qKg-cmhPz_gN6nWCpg-rFg@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86: relocs: build separate 32/64-bit tools
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 3:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/12/2013 01:13 PM, Kees Cook wrote:
>> Since the ELF structures and access macros change size based on 32 vs
>> 64 bits, build a separate 32-bit relocs tool (for handling realmode
>> and 32-bit relocations), and a 64-bit relocs tool (for handling 64-bit
>> kernel relocations).
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> --
>> This is ugly with the "cp". Is there some other cleaner way to trigger
>> two builds with different defines from the same source file?
>
> There definitely is.
>
> Have simple wrapper files which do:
>
> /* relocs_32.c */
> #define ELF_BITS 32
> #include "relocs.c"
>
> /* relocs_64.c */
> #define ELF_BITS 64
> #include "relocs.c"

That's what I did in my first pass, but it seemed even worse to me. I
will go back to this.

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
