Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaIALsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:48:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38667 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbaIALsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:48:04 -0400
Date: Mon, 1 Sep 2014 12:47:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system
	call
Message-ID: <20140901114751.GG30401@n2100.arm.linux.org.uk>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <53FD72E2.4020103@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FD72E2.4020103@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 02:55:46PM +0900, AKASHI Takahiro wrote:
> 1)
> setting x0 to -ENOSYS is necessary because, otherwise, user-issued syscall(-1) will
> return a bogus value when audit tracing is on.
>
> Please note that, on arm,
>                  not traced      traced
>                  ------          ------
> syscall(-1)      aborted         OOPs(BUG_ON)
> syscall(-3000)   aborted         aborted
> syscall(1000)    ENOSYS          ENOSYS

Two points here:

1. You've found a case which causes a BUG_ON().  Where is the bug report
   for this, so the problem can be investigated and resolved?

2. What do you mean by "aborted" ?

Please, if you find a problem with 32-bit ARM, report it.  Don't hide it,
because hiding it can be a security issue or in the case of BUG_ON(), it
could be a denial of service issue.

As you're part of Linaro, I would have thought you'd be more responsible
in this regard - after all, Linaro is supposed to be about improving the
ARM kernel...  Maybe I got that wrong, and Linaro is actually about
ensuring that the ARM kernel is stuffed full of broken features?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
