Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaJ2VBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:01:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:58920 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaJ2VBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:01:10 -0400
Date: Wed, 29 Oct 2014 22:00:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Josh Triplett <josh@joshtriplett.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 3/3] x86: Support compiling out userspace I/O (iopl
 and ioperm)
In-Reply-To: <9d77d0e4df8feb2cb55fb21689e016a3145cb7f8.1414598511.git.josh@joshtriplett.org>
Message-ID: <alpine.DEB.2.11.1410292155300.5308@nanos>
References: <7159269982aac3b732af2c33a2e3d04e2048bdfb.1414598511.git.josh@joshtriplett.org> <9d77d0e4df8feb2cb55fb21689e016a3145cb7f8.1414598511.git.josh@joshtriplett.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Josh Triplett wrote:
> v3: Eliminated several #ifdefs, and in particular almost all #ifdefs in
>     .c files, by adding a macro INIT_SET_IOPL_MASK to use in place of
>     the initializer for set_iopl_mask, and using __maybe_unused rather
>     than wrapping function definitions in #ifdef.  Rebased on v3.18-rc1.
>     Recomputed bloat-o-meter.

Can you please split this patch into smaller pieces?

    - Seperate the code move to header files
    - Seperate the macro stuff
    - Add the #ifdef CONFIG_.... changes

Thanks,

	tglx
