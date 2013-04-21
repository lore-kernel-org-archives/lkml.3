Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3DUTq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 15:46:27 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47430 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3DUTqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 15:46:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130421091342.GD31470@gmail.com>
References: <20130419231638.GA20133@www.outflux.net>
	<20130421091342.GD31470@gmail.com>
Date: Sun, 21 Apr 2013 12:46:24 -0700
X-Google-Sender-Auth: Vp_DhHaEkt2pkwltCsjpvSN0tTw
Message-ID: <CAGXu5jKFSmBTQ5Ay+MypkAStvDMrkWMNHCz4XGyy4bVjyVAnHg@mail.gmail.com>
Subject: Re: [PATCH] x86: kaslr: move ELF relocation handling to C
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Olaf Hering <olaf@aepfle.de>,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jacob Shin <jacob.shin@amd.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 2:13 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Moves the relocation handling into C, after decompression. Only
>> kernels that need relocation support will use the code. The new
>> CONFIG_RANDOMIZE_BASE does not yet do anything except turn on this logic
>> for 64-bit kernels.
>
> So why not keep the inactive CONFIG_RANDOMIZE_BASE hunks in a separate
> patch, and just have this one clean, orthogonal patch that moves
> relocation handling into C?

I had wanted there to be a way to test building with 64-bit
relocations. With this patch and CONFIG_RANDOMIZE_BASE=y, I could do
that. Would you rather I remove those pieces?

-Kees

--
Kees Cook
Chrome OS Security
