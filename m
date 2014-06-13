Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaFMUlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:41:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56601 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaFMUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:41:23 -0400
MIME-Version: 1.0
In-Reply-To: <1402457121-8410-7-git-send-email-keescook@chromium.org>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org> <1402457121-8410-7-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jun 2014 13:41:02 -0700
Message-ID: <CALCETrVYVB0pMj61T9ZCAhgL6WYHAdDjiDe81O0e4tTQLtjDiQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] seccomp: add "seccomp" syscall
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        David Drysdale <drysdale@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        John Johansen <john.johansen@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 8:25 PM, Kees Cook <keescook@chromium.org> wrote:
> This adds the new "seccomp" syscall with both an "operation" and "flags"
> parameter for future expansion. The third argument is a pointer value,
> used with the SECCOMP_SET_MODE_FILTER operation. Currently, flags must
> be 0. This is functionally equivalent to prctl(PR_SET_SECCOMP, ...).

Question for the linux-abi people:

What's the preferred way to do this these days?  This syscall is a
general purpose "adjust the seccomp state" thing.  The alternative
would be a specific new syscall to add a filter with a flags argument.

--Andy
