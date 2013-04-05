Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3DEMMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:12:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161177Ab3DEMMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:12:53 -0400
Date: Fri, 5 Apr 2013 14:12:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.00.1304051408540.23195@twin.jikos.cz>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Kees Cook wrote:

> This creates CONFIG_RANDOMIZE_BASE, so that the base offset of the kernel
> can be randomized at boot.
> 
> This makes kernel vulnerabilities harder to reliably exploit, especially
> from remote attacks and local processes in seccomp containers. Keeping
> the location of kernel addresses secret becomes very important when using
> this feature, so enabling kptr_restrict and dmesg_restrict is recommended.

If we are going to take the KASLR path at all, and assuming this is done 
purely because of security, I'd suggest not only vaguely mentioning this 
requirement in the changelog (and calling it recommendation), but make it 
a hard prerequisity.

Without kernel addresses being invisible to userspace, this feature is 
completely useless, but might provide very false sense of security if just 
blindly enabled by random Joe Bofh.

-- 
Jiri Kosina
SUSE Labs

