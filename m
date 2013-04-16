Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518Ab3DPWWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:22:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353Ab3DPWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:22:24 -0400
Message-ID: <516DCEF3.6030803@zytor.com>
Date: Tue, 16 Apr 2013 15:21:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 4/6] x86: relocs: build separate 32/64-bit tools
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-5-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 01:13 PM, Kees Cook wrote:
> Since the ELF structures and access macros change size based on 32 vs
> 64 bits, build a separate 32-bit relocs tool (for handling realmode
> and 32-bit relocations), and a 64-bit relocs tool (for handling 64-bit
> kernel relocations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> --
> This is ugly with the "cp". Is there some other cleaner way to trigger
> two builds with different defines from the same source file?

There definitely is.

Have simple wrapper files which do:

/* relocs_32.c */
#define ELF_BITS 32
#include "relocs.c"

/* relocs_64.c */
#define ELF_BITS 64
#include "relocs.c"

	-hpa


